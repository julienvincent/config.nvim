;; extends

;; This is an extension of the default queries provided by the nvim-treesitter plugin.
;;
;; This specifically tweaks the highlighting of keywords which were previously
;; using `@constant` but which now use @namespace/@keyword for the namespace
;; and name components respectively.
;;
;; Find the original this is based off here:
;; https://github.com/nvim-treesitter/nvim-treesitter/blob/8dd40c7609c04d7bad7eb21d71f78c3fa4dc1c2c/queries/clojure/highlights.scm

(kwd_ns) @namespace
(kwd_name) @keyword
