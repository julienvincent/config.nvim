" Vim syntax file
" Language: Numscript

if exists("b:current_syntax")
  finish
endif

" Keywords
syntax keyword NumscriptKeyword vars send set_tx_meta
syntax keyword NumscriptKeyword source destination allowing remaining to from

" Variables
syntax match NumscriptVariable "\$\w\+"

" Accounts
syntax match NumscriptAccountAt "@" contained
syntax match NumscriptAccountSeparator ":" contained
syntax match NumscriptAccount "@\w\+\(:\w\+\)*" contains=numscriptAccountAt,numscriptAccountSeparator

" Numbers and Currencies
syntax match NumscriptNumber "\<\d\+\>"
syntax match NumscriptCurrency "\<[A-Z]\+\>" nextgroup=numscriptAssetSeparator,numscriptAssetPrecision skipwhite
syntax match NumscriptAssetSeparator "/" contained nextgroup=numscriptAssetPrecision
syntax match NumscriptAssetPrecision "\d\+" contained

" Operators
syntax match NumscriptOperator "="
syntax match NumscriptOperator "{"
syntax match NumscriptOperator "}"
syntax match NumscriptOperator "("
syntax match NumscriptOperator ")"
syntax match NumscriptOperator "\["
syntax match NumscriptOperator "\]"
syntax match NumscriptOperator "%"

" Comments (assuming # for single-line comments)
syntax match NumscriptComment "#.*$"

" Strings
syntax region NumscriptString start=/"/ skip=/\\"/ end=/"/ 

" Special keywords
syntax keyword NumscriptSpecial unbounded overdraft max

" Define the default highlighting
highlight default link NumscriptKeyword Keyword
highlight default link NumscriptVariable Identifier
highlight default link NumscriptAccount Special
highlight default link NumscriptAccountAt Operator
highlight default link NumscriptAccountSeparator Delimiter
highlight default link NumscriptNumber Number
highlight default link NumscriptCurrency Constant
highlight default link NumscriptAssetSeparator Operator
highlight default link NumscriptAssetPrecision Number
highlight default link NumscriptOperator Operator
highlight default link NumscriptComment Comment
highlight default link NumscriptString String
highlight default link NumscriptSpecial Type

let b:current_syntax = "numscript"
