;; extends

((list_lit
  ((sym_lit) @def-type
   (sym_lit) @def-name
   (str_lit) @docstring @injection.content)
   (map_lit)?

   (_)+)

  (#match? @def-type "^(def|defprotocol)$")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "markdown"))

((list_lit
  ((sym_lit) @def-type
   (sym_lit) @def-name
   (str_lit)? @docstring @injection.content)
   (map_lit)?

   [
    (vec_lit)
    (list_lit (vec_lit))+
   ])

  (#match? @def-type "^(defn-?|defmacro)$")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "markdown"))

;; Match ns
((list_lit
  ((sym_lit) @fn-type
   (sym_lit) @ns-name
   (#eq? @fn-type "ns")

   (str_lit)? @docstring @injection.content)
   (map_lit)?)

  (_)*

  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "markdown"))

(list_lit
  ((sym_lit) @fn-name
   (#eq? @fn-name "defprotocol")
   (sym_lit) @protocol-name

   (str_lit)?)

  (list_lit
    (sym_lit)
    (vec_lit)+
    (str_lit) @docstring @injection.content)

  (#offset! @injection.content 0 1 0 -1)
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

  (str_lit) @injection.content)

  (#eq? @def-type "def")
  (#eq? @var.meta "sql")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

((list_lit
  .

  (sym_lit) @fn-name

  (_)

  [
    (str_lit) @injection.content

    (vec_lit
      (str_lit) @injection.content)
  ])

  (#any-of? @fn-name "jdbc/execute!" "jdbc/execute-one!" "jdbc/plan")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))

((list_lit
  .

  (sym_lit) @fn-name

  (_)

  (_)

  (vec_lit
    (str_lit) @injection.content))

  (#match? @fn-name "\/(select!|select-one!)")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))
