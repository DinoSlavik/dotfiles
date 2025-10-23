if exists("b:current_syntax")
  finish
endif

" === Ключові слова ===
syn keyword ignisStatement return if else elif while loop for break continue
syn keyword ignisType int void char struct ptr
syn keyword ignisModifier mut const
syn keyword ignisOperator or and not xor bor band bnot bxor nor nand nnot xnor nbor nband nbnot nbxor
syn keyword ignisPointerOp addr deref alloc new free

" === Інші елементи синтаксису ===

" Спец. слова в коментарях (має йти перед правилом для коментарів)
syn keyword ignisTodo contained TODO FIXME NOTE QUES XXX

" Ескейп-послідовності (має йти перед правилом для рядків/символів)
syn match ignisEscape contained "\\[nt\\\"']"

" Коментарі (з підтримкою ignisTodo)
syn match ignisComment "//.*$" contains=ignisTodo
"
" Багаторядкові коментарі (з підтримкою ignisTodo)
syn region ignisMultiComment start="/\*" end="\*/" contains=ignisTodo

" Рядкові та символьні літерали (з підтримкою ignisEscape)
syn region ignisString start=/"/ end=/"/ contains=ignisEscape
syn region ignisChar start=/'/ end=/'/ contains=ignisEscape

" Числа
syn match ignisNumber "\<\d\+\>"

" Імена функцій
syn match ignisFunction "\w\+\s*\ze("

" Ім'я структури у її визначенні
syn match ignisStructName "\vstruct\s+\zs\w+"
" Ім'я константи у її визначенні
syn match ignisConstant "\vconst\s+(ptr\s+)?\w+\s+\zs\w+"


" === Зв'язування з групами підсвітки ===
hi def link ignisStatement Statement
hi def link ignisType Type
hi def link ignisModifier StorageClass
hi def link ignisOperator Operator
hi def link ignisPointerOp Operator
hi def link ignisComment Comment
hi def link ignisMultiComment Comment
hi def link ignisString String
hi def link ignisChar Character
hi def link ignisNumber Number
hi def link ignisFunction Function
hi def link ignisStructName Structure
hi def link ignisConstant Constant
hi def link ignisTodo Todo
hi def link ignisEscape SpecialChar

let b:current_syntax = "ignis"
