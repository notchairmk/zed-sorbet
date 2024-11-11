; Copied from upstream Ruby extension https://github.com/zed-extensions/ruby/tree/784b0cbd31a46a453f6c24d2f9dae6eda86f4ac2/languages/ruby

("[" @open "]" @close)
("{" @open "}" @close)
("\"" @open "\"" @close)
("do" @open "end" @close)

(block_parameters "|" @open "|" @close)
(interpolation "#{" @open "}" @close)

(if "if" @open "end" @close)
(unless "unless" @open "end" @close)
(begin "begin" @open "end" @close)
(module "module" @open "end" @close)
(_ . "def" @open "end" @close)
(_ . "class" @open "end" @close)
