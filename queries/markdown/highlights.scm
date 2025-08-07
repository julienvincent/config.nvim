;; extends

;; === MDX

((inline) @_inline (#lua-match? @_inline "^%s*import")) @nospell
((inline) @_inline (#lua-match? @_inline "^%s*export")) @nospell

;; Highlight {/* */} as a comment. This only partly works, in a paragraph any text below
;; the comment will break the highlight matching.
((inline) @comment
  (#lua-match? @comment "^%s*%{%s*/%*.*%*/%s*%}%s*$"))

;; ===
