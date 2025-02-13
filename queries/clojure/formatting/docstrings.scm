((list_lit
  ((sym_lit) @def-type
   (#any-of? @def-type "def" "defprotocol")
   (sym_lit) @def-name
   (str_lit)? @docstring)
   (map_lit)?)

  (_)+

  (#offset! @docstring 0 1 0 -1))

((list_lit
  ((sym_lit) @def-type
   (#any-of? @def-type
    "defn"
    "defn-"
    "defmacro")
   (sym_lit) @def-name
   (str_lit)? @docstring)
   (map_lit)?

   [
    (vec_lit)
    (list_lit (vec_lit))+
   ])

  (#offset! @docstring 0 1 0 -1))

;; Match ns
((list_lit
  ((sym_lit) @fn-type
   (sym_lit) @ns-name
   (#eq? @fn-type "ns")

   (str_lit)? @docstring)
   (map_lit)?)

  (_)*

  (#offset! @docstring 0 1 0 -1))

(list_lit
  ((sym_lit) @fn-name
   (#eq? @fn-name "defprotocol")
   (sym_lit) @protocol-name

   (str_lit)?)

  (list_lit
    (sym_lit)
    (vec_lit)+
    (str_lit) @docstring)

  (#offset! @docstring 0 1 0 -1))
