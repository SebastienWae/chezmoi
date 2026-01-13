; extends

; Inject SQL into strings starting with /*SQL*/
((string (string_content) @injection.content)
  (#lua-match? @injection.content "^/%*SQL%*/")
  (#set! injection.language "sql")
  (#set! injection.include-children)
  (#set! injection.priority 200))
