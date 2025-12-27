local has_blink, blink = pcall(require, "blink.cmp")
local capabilities = (has_blink and blink.get_lsp_capabilities) and blink.get_lsp_capabilities()
    or vim.lsp.protocol.make_client_capabilities()

local has_schemastore, schemastore = pcall(require, "schemastore")
local function json_schemas()
  return has_schemastore and schemastore.json.schemas() or {}
end

local function yaml_schemas()
  return has_schemastore and schemastore.yaml.schemas() or {}
end

local servers = {
  lua_ls = {
    cmd = { "lua-language-server", },
    filetypes = { "lua", },
    root_markers = {
      ".emmyrc.json",
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git",
    },
    settings = {
      Lua = {
        codeLens = { enable = true, },
        hint = { enable = true, semicolon = "Disable", },
        telemetry = { enable = false, },
      },
    },
  },
  vtsls = {
    cmd = { "vtsls", "--stdio", },
    init_options = {
      hostInfo = "neovim",
    },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    root_dir = function(bufnr, on_dir)
      local root_markers = {
        "package-lock.json",
        "yarn.lock",
        "pnpm-lock.yaml",
        "bun.lockb",
        "bun.lock",
        ".git",
      }
      if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock", }) then
        return
      end
      local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
      on_dir(project_root)
    end,
  },
  dockerls = {
    cmd = { "docker-language-server", "start", "--stdio", },
    filetypes = { "dockerfile", "yaml", },
    root_dir = function(bufnr, on_dir)
      local ft = vim.bo[bufnr].filetype
      local name = vim.api.nvim_buf_get_name(bufnr)

      if ft == "dockerfile" then
        local project_root = vim.fs.root(bufnr, { ".git", }) or vim.fn.getcwd()
        on_dir(project_root)
        return
      end

      if ft ~= "yaml" then
        return
      end

      local base = vim.fn.fnamemodify(name, ":t")
      local compose_files = {
        ["docker-compose.yml"] = true,
        ["docker-compose.yaml"] = true,
        ["compose.yml"] = true,
        ["compose.yaml"] = true,
      }
      if not compose_files[base] then
        return
      end

      local project_root = vim.fs.root(bufnr, {
        ".git",
        "docker-compose.yml",
        "docker-compose.yaml",
        "compose.yml",
        "compose.yaml",
      }) or vim.fn.getcwd()
      on_dir(project_root)
    end,
  },
  jsonls = {
    cmd = { "vscode-json-language-server", "--stdio", },
    filetypes = { "json", "jsonc", },
    settings = {
      json = {
        schemas = json_schemas(),
        validate = { enable = true, },
      },
    },
  },
  yamlls = {
    cmd = { "yaml-language-server", "--stdio", },
    filetypes = { "yaml", },
    settings = {
      yaml = {
        format = { enable = true, },
        schemas = yaml_schemas(),
        schemaStore = { enable = false, url = "", },
        validate = true,
      },
    },
  },
  taplo = {
    cmd = { "taplo", "lsp", "stdio", },
    filetypes = { "toml", },
  },
  tailwindcss = {
    cmd = { "tailwindcss-language-server", "--stdio", },
    filetypes = {
      "html",
      "css",
      "scss",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
  },
  bashls = {
    cmd = { "bash-language-server", "start", },
    filetypes = { "sh", "bash", "zsh", },
  },
  ty = {
    cmd = { "ty", "server", },
    filetypes = { "python", },
  },
  ruff = {
    cmd = { "ruff", "server", },
    filetypes = { "python", },
  },
}

local enabled = {}
for name, config in pairs(servers) do
  vim.lsp.config(name, vim.tbl_extend("force", { capabilities = capabilities, }, config))
  enabled[#enabled + 1] = name
end

vim.lsp.enable(enabled)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_tweaks", { clear = true, }),
  callback = function(args)
    local client_id = args.data and args.data.client_id or nil
    if not client_id then
      return
    end

    local client = vim.lsp.get_client_by_id(client_id)
    if not client then
      return
    end

    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype

    if client.name == "dockerls" and ft == "yaml" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    elseif client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
})

local function lsp_server_names()
  return vim.tbl_keys(vim.lsp.config._configs or {})
end

local function lsp_server_complete(arglead)
  local matches = {}
  for _, name in ipairs(lsp_server_names()) do
    if name:find("^" .. vim.pesc(arglead)) then
      matches[#matches + 1] = name
    end
  end
  table.sort(matches)
  return matches
end

local function lsp_config_for(name)
  local config = (vim.lsp.config._configs or {})[name]
  if not config then
    return nil
  end
  local copy = vim.deepcopy(config)
  copy.name = name
  return copy
end

local function buf_clients_by_name(bufnr, name)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, })
  if not name or name == "" then
    return clients
  end
  local filtered = {}
  for _, client in ipairs(clients) do
    if client.name == name then
      filtered[#filtered + 1] = client
    end
  end
  return filtered
end

local function stop_lsp_client(client)
  local id = type(client) == "number" and client or client.id
  local resolved = vim.lsp.get_client_by_id(id)
  if not resolved then
    vim.notify("No LSP client with id: " .. id, vim.log.levels.WARN)
    return
  end
  resolved:stop()
end

local function start_lsp_server(name, bufnr, opts)
  opts = opts or {}
  local config = lsp_config_for(name)
  if not config then
    vim.notify("Unknown LSP server: " .. name, vim.log.levels.ERROR)
    return
  end


  if not opts.force and #buf_clients_by_name(bufnr, name) > 0 then
    vim.notify("LSP client already attached: " .. name, vim.log.levels.INFO)
    return
  end

  vim.lsp.start(config, { bufnr = bufnr, })
end

local function open_centered_markdown(lines)
  local ok, Snacks = pcall(require, "snacks")
  if not ok then
    vim.notify("snacks.nvim is required for :LspInfo", vim.log.levels.ERROR)
    return
  end

  Snacks.win({
    text = lines,
    ft = "markdown",
    title = " LSP Info ",
    title_pos = "center",
    border = "single",
    width = 0.8,
    height = 0.8,
    enter = true,
    wo = {
      wrap = true,
      conceallevel = 2,
      concealcursor = "nc",
      spell = false,
      signcolumn = "no",
    },
  })
end

for _, cmd in ipairs({ "LspInfo", "LspLog", "LspStart", "LspStop", "LspRestart", }) do
  pcall(vim.api.nvim_del_user_command, cmd)
end

vim.api.nvim_create_user_command("LspStart", function(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local args = vim.split(opts.args, "%s+", { trimempty = true, })
  local server_names = args

  if #server_names == 0 then
    local ft = vim.bo[bufnr].filetype
    server_names = {}
    for name, config in pairs(vim.lsp.config._configs or {}) do
      local filetypes = config.filetypes
      if filetypes and vim.tbl_contains(filetypes, ft) then
        server_names[#server_names + 1] = name
      end
    end
    table.sort(server_names)
  end

  if #server_names == 0 then
    vim.notify("No configured LSP servers match this buffer", vim.log.levels.WARN)
    return
  end

  for _, name in ipairs(server_names) do
    start_lsp_server(name, bufnr)
  end
end, {
  nargs = "*",
  complete = lsp_server_complete,
  desc = "Start configured LSP servers",
})

vim.api.nvim_create_user_command("LspStop", function(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local args = vim.split(opts.args, "%s+", { trimempty = true, })
  local names = args

  if #names == 0 then
    local clients = buf_clients_by_name(bufnr)
    if #clients == 0 then
      vim.notify("No LSP clients attached", vim.log.levels.INFO)
      return
    end
    for _, client in ipairs(clients) do
      stop_lsp_client(client)
    end
    return
  end

  for _, name in ipairs(names) do
    local clients = buf_clients_by_name(bufnr, name)
    if #clients == 0 then
      vim.notify("No LSP client attached: " .. name, vim.log.levels.WARN)
    else
      for _, client in ipairs(clients) do
        stop_lsp_client(client)
      end
    end
  end
end, {
  nargs = "*",
  complete = lsp_server_complete,
  desc = "Stop LSP clients attached to buffer",
})

vim.api.nvim_create_user_command("LspRestart", function(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  local args = vim.split(opts.args, "%s+", { trimempty = true, })
  local names = args

  if #names == 0 then
    local clients = buf_clients_by_name(bufnr)
    if #clients == 0 then
      vim.notify("No LSP clients attached", vim.log.levels.INFO)
      return
    end
    names = {}
    for _, client in ipairs(clients) do
      names[#names + 1] = client.name
    end
  end

  local deduped, seen = {}, {}
  for _, name in ipairs(names) do
    if name ~= "" and not seen[name] then
      seen[name] = true
      deduped[#deduped + 1] = name
    end
  end
  if #deduped == 0 then
    vim.notify("No LSP server names provided", vim.log.levels.WARN)
    return
  end

  for _, name in ipairs(deduped) do
    if not lsp_config_for(name) then
      vim.notify("Unknown LSP server: " .. name, vim.log.levels.ERROR)
    else
      for _, client in ipairs(buf_clients_by_name(bufnr, name)) do
        stop_lsp_client(client)
      end

      local tries = 20
      local function try_start()
        if #buf_clients_by_name(bufnr, name) == 0 then
          start_lsp_server(name, bufnr, { force = true, })
          return
        end

        tries = tries - 1
        if tries <= 0 then
          vim.notify("LSP client did not stop in time: " .. name, vim.log.levels.WARN)
          return
        end
        vim.defer_fn(try_start, 100)
      end

      vim.defer_fn(try_start, 100)
    end
  end
end, {
  nargs = "*",
  complete = lsp_server_complete,
  desc = "Restart LSP clients for buffer",
})

vim.api.nvim_create_user_command("LspLog", function()
  local ok, Snacks = pcall(require, "snacks")
  if not ok then
    vim.notify("snacks.nvim is required for :LspLog", vim.log.levels.ERROR)
    return
  end

  local log_file = vim.lsp.log.get_filename()
  if not log_file or log_file == "" then
    vim.notify("No LSP log file found", vim.log.levels.WARN)
    return
  end

  if not vim.uv.fs_stat(log_file) then
    vim.notify("LSP log file does not exist: " .. log_file, vim.log.levels.WARN)
    return
  end

  Snacks.win({
    file = log_file,
    ft = "log",
    title = " LSP Log ",
    title_pos = "center",
    border = "single",
    width = 0.9,
    height = 0.8,
    enter = true,
    wo = {
      wrap = false,
      spell = false,
      signcolumn = "no",
    },
  })
end, {
  desc = "Open the LSP log file",
})

vim.api.nvim_create_user_command("LspInfo", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local clients = vim.lsp.get_clients({ bufnr = bufnr, })

  local lines = {}
  lines[#lines + 1] = "# LSP Info"
  lines[#lines + 1] = ""
  lines[#lines + 1] = "## Buffer"
  lines[#lines + 1] = ("- bufnr: %d"):format(bufnr)
  lines[#lines + 1] = ("- filetype: %s"):format(ft == "" and "(none)" or ft)
  lines[#lines + 1] = ""

  lines[#lines + 1] = "## Attached Clients"
  if #clients == 0 then
    lines[#lines + 1] = "- (none)"
  else
    table.sort(clients, function(a, b)
      return a.name < b.name
    end)
    for _, client in ipairs(clients) do
      local root_dir = client.config and client.config.root_dir or nil
      lines[#lines + 1] = ("- %s (id: %d)%s"):format(
        client.name,
        client.id,
        root_dir and (" root: " .. root_dir) or ""
      )
    end
  end
  lines[#lines + 1] = ""

  lines[#lines + 1] = "## Configured Servers"
  local configs = vim.lsp.config._configs or {}
  local names = vim.tbl_keys(configs)
  table.sort(names)
  for _, name in ipairs(names) do
    local config = configs[name]
    local filetypes = config.filetypes
    local ft_note = ""
    if filetypes and ft ~= "" and vim.tbl_contains(filetypes, ft) then
      ft_note = " (matches buffer)"
    end
    lines[#lines + 1] = ("- %s%s"):format(name, ft_note)
  end

  open_centered_markdown(lines)
end, {
  desc = "Show LSP client/configuration info",
})
