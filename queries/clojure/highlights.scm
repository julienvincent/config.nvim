;; This is an override of the default queries provided by the clojure grammar.
;;
;; This specifically tweaks the highlighting of keywords which were previously
;; using `@constant` but which now use @namespace/@keyword for the namespace
;; and name components respectively.
;;
;; Find the original this is based off here:
;; https://github.com/sogaiu/tree-sitter-clojure/blob/f4236d4da8aa92bc105d9c118746474c608e6af7/queries/highlights.scm

(kwd_ns) @namespace
(kwd_name) @keyword

(num_lit) @number

[(char_lit) (str_lit)] @string

[(bool_lit) (nil_lit)] @constant.builtin

(comment) @comment

["'" "`" "~" "@" "~@"] @operator
