; Copied from upstream Ruby extension https://github.com/zed-extensions/ruby/tree/784b0cbd31a46a453f6c24d2f9dae6eda86f4ac2/languages/ruby

(heredoc_body
  (heredoc_content) @content
  (heredoc_end) @language
  (#downcase! @language))

((regex
  (string_content) @content)
  (#set! "language" "regex"))
