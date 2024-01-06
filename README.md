This is a major mode for editing Makesfile with the aid of tree-sitter.

The code is currently pretty bare-bones; `make-mode` was choking on my
`define` directives, and I did just enough to highlight the file in
question.

The bulk of the code is based on an aticle at
[MasteringEmacs](https://www.masteringemacs.org/article/lets-write-a-treesitter-major-mode).

The tree-sitter grammer I used was created by [alemuller](https://github.com/alemuller/tree-sitter-make).

Then I referred to the elisp info pgaes, the official TS
[docs](https://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries)
and `ruby-ts-mode.el` for clarifications and some of the commentary
text.
