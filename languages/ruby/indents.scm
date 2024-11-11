; Copied from upstream Ruby extension https://github.com/zed-extensions/ruby/tree/784b0cbd31a46a453f6c24d2f9dae6eda86f4ac2/languages/ruby

(method "end" @end) @indent
(class "end" @end) @indent
(module "end" @end) @indent
(begin "end" @end) @indent
(singleton_method "end" @end) @indent
(do_block "end" @end) @indent

(then) @indent
(call) @indent

(ensure) @outdent
(rescue) @outdent
(else) @outdent


(_ "[" "]" @end) @indent
(_ "{" "}" @end) @indent
(_ "(" ")" @end) @indent
