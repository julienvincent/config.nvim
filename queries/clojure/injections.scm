;; extends

((list_lit
  (sym_lit) @def-type
  (sym_lit) @def-name
  (str_lit
    (str_content_lit) @injection.content) @docstring)

  (#match? @def-type "^(defn-?|defmacro|defprotocol|ns)$")
  (#set! injection.language "markdown"))

;; This example is for defining a clojure SQL language injection for clojure forms that look like:
;;
;; (def ^:sql query "SELECT * FROM foo;")
;;
;; However this does not work due to the `str_lit` node including the wrapping '"' chars. This would
;; require a patch to the clojure TreeSitter grammer to further break the str_lit node into
;; sub-nodes.
((list_lit
  (sym_lit) @def-type

  (sym_lit
    (meta_lit 
      (kwd_lit
        (kwd_name) @var.meta)))

  (str_lit
    (str_content_lit) @var.value @injection.content))

  (#eq? @def-type "def")
  (#eq? @var.meta "sql")
  (#set! injection.language "sql"))

((list_lit
  .

  (sym_lit) @fn-name

  (_)

  [
    (str_lit
      (str_content_lit) @var.value @injection.content)

    (vec_lit
      (str_lit
        (str_content_lit) @var.value @injection.content))
  ])

  (#any-of? @fn-name "jdbc/execute!" "jdbc/execute-one!" "jdbc/plan")
  (#set! injection.language "sql"))

((list_lit
  .

  (sym_lit) @fn-name

  (_)

  (_)

  (vec_lit
    (str_lit
      (str_content_lit) @var.value @injection.content)))

  (#match? @fn-name "\/(select!|select-one!)")
  (#set! injection.language "sql"))
