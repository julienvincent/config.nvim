;; extends

((string_content) @injection.content
  (#match? @injection.content "^(SET|TRUNCATE|SELECT|CREATE|DELETE|ALTER|UPDATE|DROP|INSERT|WITH)")
  (#set! injection.language "sql"))
