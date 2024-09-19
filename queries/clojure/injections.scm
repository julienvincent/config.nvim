;; extends

((list_lit
  (sym_lit) @def-type
  (sym_lit) @def-name
  (str_lit) @docstring @injection.content)

  (#match? @def-type "^(defn-?|defmacro|defprotocol|ns)$")
  (#set! injection.language "markdown"))
