(list_lit 
  (sym_lit) @var-name
  (#any-of? @var-name
   "def"
   "defn"
   "defn-"
   "defmacro")

  (str_lit
    (str_content_lit) @doc-string))
