; Functions
; ---------
; named function (binding whose value is a function)
(binding
  (function_expression)) @function.outer

; anonymous function
(function_expression
  body: (_) @function.inner) @function.outer

; Parameters
; ----------
; formal arguments in { ... } pattern
((formals
  "," @_start
  .
  (formal) @parameter.inner)
  (#make-range! "parameter.outer" @_start @parameter.inner))

((formals
  .
  (formal) @parameter.inner
  .
  ","? @_end)
  (#make-range! "parameter.outer" @parameter.inner @_end))

; single identifier argument: x: body
(function_expression
  (_) @parameter.outer
  body: (_))

; Comments
; --------
; leave space after comment marker if there is one
((comment) @comment.inner @comment.outer
  (#offset! @comment.inner 0 2 0)
  (#lua-match? @comment.outer "# .*"))

; else remove everything except comment marker
((comment) @comment.inner @comment.outer
  (#offset! @comment.inner 0 1 0))

; Conditionals
; ------------
(if_expression
  condition: (_) @conditional.inner) @conditional.outer

(if_expression
  consequence: (_) @conditional.inner)

(if_expression
  alternative: (_) @conditional.inner)

; Numbers
; -------
[
  (integer_expression)
  (float_expression)
] @number.inner

; Assignments (bindings)
; ----------------------
(binding
  attrpath: (_) @assignment.lhs
  expression: (_) @assignment.inner @assignment.rhs) @assignment.outer

(binding
  attrpath: (_) @assignment.inner)

; Function calls
; --------------
(apply_expression
  argument: (_) @call.inner) @call.outer

; Blocks
; ------
; let ... in ... expression
(let_expression
  body: (_) @block.inner) @block.outer

; attribute sets { ... }
(attrset_expression
  (binding_set) @block.inner) @block.outer

(rec_attrset_expression
  (binding_set) @block.inner) @block.outer

; Return (body of let expression, i.e. expression after "in")
; ------------------------------------------------------------
(let_expression
  body: (_) @return.inner) @return.outer

; Statements (individual bindings/inherits within a binding set)
; --------------------------------------------------------------
(binding_set
  (binding) @statement.outer)

(binding_set
  (inherit) @statement.outer)

(binding_set
  (inherit_from) @statement.outer)
