(list_lit 
  (sym_lit) @var-name
  (#any-of? @var-name
   "def"
   "defn"
   "defn-"
   "defmacro")

  (str_lit) @doc-string

  (#offset! @doc-string 0 1 0 -1))
