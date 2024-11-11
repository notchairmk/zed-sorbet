; Copied from upstream Ruby extension https://github.com/zed-extensions/ruby/tree/784b0cbd31a46a453f6c24d2f9dae6eda86f4ac2/languages/ruby

(
    (comment)* @context
    .
    [
        (module
            "module" @name
            name: (_) @name)
        (method
            "def" @name
            name: (_) @name
            body: (body_statement) @collapse)
        (class
            "class" @name
            name: (_) @name)
        (singleton_method
            "def" @name
            object: (_) @name
            "." @name
            name: (_) @name
            body: (body_statement) @collapse)
        ] @item
    )
