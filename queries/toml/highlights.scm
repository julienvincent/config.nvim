;; extends

(bare_key) @label
(quoted_key) @text

(quoted_key 
  "'" @string)

("[" (bare_key) @annotation "]") 
("["
 (dotted_key
   (bare_key) @annotation) 
 "]") 

"=" @punctuation
