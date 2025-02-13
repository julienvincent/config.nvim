(list_lit 
  (sym_lit) @var-name
  (#any-of? @var-name
   "def"
   "defn"
   "defn-"
   "defmacro"
   "defprotocol")

  (str_lit) @doc-string

  (_)

  (#offset! @doc-string 0 1 0 -1))

(list_lit
  (sym_lit) @var-name
  (#eq? @var-name "defprotocol")

  (str_lit)?

  (list_lit
    (sym_lit)
    (vec_lit)+
    (str_lit) @doc-string)

  (#offset! @doc-string 0 1 0 -1))
