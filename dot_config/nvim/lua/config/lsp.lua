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

-- Mirrors `lspconfig.util.insert_package_json()` so we can keep
-- Biome's upstream root/config detection without depending on nvim-lspconfig.
local function root_markers_with_field(root_files, new_names, field, fname)
  local path = vim.fn.fnamemodify(fname, ":h")
  local found = vim.fs.find(new_names, { path = path, upward = true, type = "file", })

  for _, f in ipairs(found or {}) do
    for line in io.lines(f) do
      if line:find(field) then
        root_files[#root_files + 1] = vim.fs.basename(f)
        break
      end
    end
  end

  return root_files
end

local function insert_package_json(root_files, field, fname)
  return root_markers_with_field(root_files, { "package.json", "package.json5", }, field, fname)
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
  biome = {
    cmd = function(dispatchers, config)
      local cmd = "biome"
      local local_cmd = (config or {}).root_dir and (config.root_dir .. "/node_modules/.bin/biome")
      if local_cmd and vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
      return vim.lsp.rpc.start({ cmd, "lsp-proxy", }, dispatchers)
    end,
    filetypes = {
      "astro",
      "css",
      "graphql",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "svelte",
      "typescript",
      "typescript.tsx",
      "typescriptreact",
      "vue",
    },
    workspace_required = true,
    root_dir = function(bufnr, on_dir)
      local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", }
      root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git", }, }
          or vim.list_extend(root_markers, { ".git", })

      -- exclude deno
      if vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "deno.lock", }) then
        return
      end

      local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

      local filename = vim.api.nvim_buf_get_name(bufnr)
      local biome_config_files = { "biome.json", "biome.jsonc", }
      biome_config_files = insert_package_json(biome_config_files, "biome", filename)

      local is_buffer_using_biome = vim.fs.find(biome_config_files, {
        path = filename,
        type = "file",
        limit = 1,
        upward = true,
        stop = vim.fs.dirname(project_root),
      })[1]
      if not is_buffer_using_biome then
        return
      end

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
        format = { enable = true, },
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
