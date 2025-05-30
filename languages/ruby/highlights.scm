; Copied from upstream Ruby extension https://github.com/zed-extensions/ruby/tree/784b0cbd31a46a453f6c24d2f9dae6eda86f4ac2/languages/ruby

; Keywords

[
  "alias"
  "and"
  "begin"
  "break"
  "case"
  "class"
  "def"
  "do"
  "else"
  "elsif"
  "end"
  "ensure"
  "for"
  "if"
  "in"
  "module"
  "next"
  "or"
  "rescue"
  "retry"
  "return"
  "then"
  "unless"
  "until"
  "when"
  "while"
  "yield"
] @keyword

((identifier) @keyword
 (#match? @keyword "^(private|protected|public)$"))

; Function calls

((identifier) @function.method.builtin
 (#eq? @function.method.builtin "require"))

"defined?" @function.method.builtin

(call
  method: [(identifier) (constant)] @function.method)

; Function definitions

(alias (identifier) @function.method)
(setter (identifier) @function.method)
(method name: [(identifier) (constant)] @function.method)
(singleton_method name: [(identifier) (constant)] @function.method)
(method_parameters [
  (identifier) @variable.parameter
  (optional_parameter name: (identifier) @variable.parameter)
  (keyword_parameter [name: (identifier) (":")] @variable.parameter)
  ])

(block_parameters (identifier) @variable.parameter)

; Identifiers

((identifier) @constant.builtin
 (#match? @constant.builtin "^__(FILE|LINE|ENCODING)__$"))

(file) @constant.builtin
(line) @constant.builtin
(encoding) @constant.builtin

(hash_splat_nil
  "**" @operator
) @constant.builtin

(global_variable) @constant

(constant) @type

((constant) @constant
 (#match? @constant "^[A-Z\\d_]+$"))

(superclass
  (constant) @type.super)

(superclass
  (scope_resolution
    (constant) @type.super))

(superclass
  (scope_resolution
    (scope_resolution
      (constant) @type.super)))

(self) @variable.special
(super) @variable.special

[
  (class_variable)
  (instance_variable)
] @variable.member


; Literals

[
  (string)
  (bare_string)
  (subshell)
  (heredoc_body)
  (heredoc_beginning)
] @string

[
  (simple_symbol)
  (delimited_symbol)
  (hash_key_symbol)
  (bare_symbol)
] @string.special.symbol

(regex) @string.regex
(escape_sequence) @string.escape

[
  (integer)
  (float)
] @number

[
  (nil)
  (true)
  (false)
] @constant.builtin

(comment) @comment

; Operators

[
  "!"
  "~"
  "+"
  "-"
  "**"
  "*"
  "/"
  "%"
  "<<"
  ">>"
  "&"
  "|"
  "^"
  ">"
  "<"
  "<="
  ">="
  "=="
  "!="
  "=~"
  "!~"
  "<=>"
  "||"
  "&&"
  ".."
  "..."
  "="
  "**="
  "*="
  "/="
  "%="
  "+="
  "-="
  "<<="
  ">>="
  "&&="
  "&="
  "||="
  "|="
  "^="
  "=>"
  "->"
  (operator)
] @operator

[
  ","
  ";"
  "."
  "::"
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "%w("
  "%i("
] @punctuation.bracket

(interpolation
  "#{" @punctuation.special
  "}" @punctuation.special) @embedded
