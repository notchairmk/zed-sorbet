; Copied from upstream Ruby extension https://github.com/zed-extensions/ruby/tree/784b0cbd31a46a453f6c24d2f9dae6eda86f4ac2/languages/ruby

(class
    "class" @context
    name: (_) @name) @item

((identifier) @context
  (#match? @context "^(private|protected|public)$")) @item

(method
    "def" @context
    name: (_) @name) @item

(singleton_method
    "def" @context
    object: (_) @context
    "." @context
    name: (_) @name) @item

(module
    "module" @context
    name: (_) @name) @item
