; extends

; Clear string highlighting for SQL strings starting with /*SQL*/
((string (string_content) @_content) @nospell @none
  (#lua-match? @_content "^/%*SQL%*/")
  (#set! priority 200))
