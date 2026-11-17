# Fixture provenance inventory

The inventory below records the original 1.0.0 fixture inputs compared as raw
bytes against tracked highlight.js source files at commit `08cb242e7d4aee787114eb04cc7ab18314d82f92`. Exact matches establish byte identity, not the original source or ownership of each contribution. Similarities are character-sequence ratios (Python difflib, autojunk disabled), not proof of derivation or ownership. Unmatched or modified files may be generated, changed, or independently authored; their provenance remains unresolved. JSON expectations were not used for attribution.

All 17 fixtures below marked as similar or extended match the corresponding
file at the pinned HighlightKit revision `524c185b0553756498c1b6a1765e8d119c4623a6`
byte-for-byte. The same check was made for the two Erlang quotation fixtures
and `xml/document-type-variations.code.txt`. HighlightKit's MIT license is
retained, alongside the highlight.js BSD-3-Clause license. This confirms where
those copies were imported from, not independent ownership of their contents.

After 1.0.0, the two Erlang inputs and the XML input named above were edited
to replace the identified quotations and named example with neutral original
text. Their syntax cases were retained and their expectations regenerated
against the pinned reference; the original inputs remain in the 1.0.0 tag and
Git history. The three table rows therefore describe the 1.0.0 inputs, not the
modified current files.

| Imported code fixture | Byte-identical highlight.js file(s) |
| --- | --- |
| `ada/default.code.txt` | Similar, not byte-identical: `test/markup/ada/default.txt` (similarity 0.988); attribution unconfirmed |
| `ada/detect-sample.code.txt` | `test/markup/ada/default.txt`, `test/detect/ada/default.txt` |
| `apache/default.code.txt` | `test/markup/apache/default.txt`, `test/detect/apache/default.txt` |
| `apache/detect-sample.code.txt` | `test/markup/apache/default.txt`, `test/detect/apache/default.txt` |
| `applescript/default.code.txt` | `test/markup/applescript/default.txt`, `test/detect/applescript/default.txt` |
| `applescript/detect-sample.code.txt` | `test/markup/applescript/default.txt`, `test/detect/applescript/default.txt` |
| `armasm/default.code.txt` | `test/markup/armasm/default.txt` |
| `armasm/detect-sample.code.txt` | `test/detect/armasm/default.txt` |
| `bash/arithmetic.code.txt` | `test/markup/bash/arithmetic.txt` |
| `bash/detect-sample.code.txt` | `test/detect/bash/default.txt` |
| `bash/escaped-apos.code.txt` | `test/markup/bash/escaped-apos.txt` |
| `bash/escaped-quote.code.txt` | `test/markup/bash/escaped-quote.txt` |
| `bash/no-numbers.code.txt` | `test/markup/bash/no-numbers.txt` |
| `bash/not-comments.code.txt` | `test/markup/bash/not-comments.txt` |
| `bash/strings.code.txt` | `test/markup/bash/strings.txt` |
| `bash/token-containing-keyword.code.txt` | `test/markup/bash/token-containing-keyword.txt` |
| `bash/variables.code.txt` | `test/markup/bash/variables.txt` |
| `basic/default.code.txt` | `test/markup/basic/default.txt`, `test/detect/basic/default.txt` |
| `basic/detect-sample.code.txt` | `test/markup/basic/default.txt`, `test/detect/basic/default.txt` |
| `c/number-literals.code.txt` | `test/markup/c/number-literals.txt` |
| `clojure/character.code.txt` | `test/markup/clojure/character.txt` |
| `clojure/comment-macro.code.txt` | `test/markup/clojure/comment-macro.txt` |
| `clojure/deps_edn.code.txt` | `test/markup/clojure/deps_edn.txt` |
| `clojure/detect-sample.code.txt` | `test/detect/clojure/default.txt` |
| `clojure/globals_definition.code.txt` | `test/markup/clojure/globals_definition.txt` |
| `clojure/number.code.txt` | `test/markup/clojure/number.txt` |
| `clojure/symbols-numbers.code.txt` | `test/markup/clojure/symbols-numbers.txt` |
| `cmake/default.code.txt` | `test/markup/cmake/default.txt` |
| `cmake/detect-sample.code.txt` | `test/detect/cmake/default.txt` |
| `coffeescript/detect-sample.code.txt` | `test/detect/coffeescript/default.txt` |
| `coffeescript/division.code.txt` | `test/markup/coffeescript/division.txt` |
| `coffeescript/freeze_bug.code.txt` | `test/markup/coffeescript/freeze_bug.txt` |
| `coffeescript/function.code.txt` | `test/markup/coffeescript/function.txt` |
| `coffeescript/regex.code.txt` | `test/markup/coffeescript/regex.txt` |
| `cpp/bitwise-keywords.code.txt` | `test/markup/cpp/bitwise-keywords.txt` |
| `cpp/bugs.code.txt` | `test/markup/cpp/bugs.txt` |
| `cpp/comments.code.txt` | `test/markup/cpp/comments.txt` |
| `cpp/detect-sample.code.txt` | `test/detect/cpp/default.txt` |
| `cpp/expression-keywords.code.txt` | `test/markup/cpp/expression-keywords.txt` |
| `cpp/function-declarations.code.txt` | `test/markup/cpp/function-declarations.txt` |
| `cpp/function-like-keywords.code.txt` | Upstream fixture is an exact prefix: `test/markup/cpp/function-like-keywords.txt`; appended content and attribution unconfirmed |
| `cpp/function-params.code.txt` | `test/markup/cpp/function-params.txt` |
| `cpp/function-title.code.txt` | `test/markup/cpp/function-title.txt` |
| `cpp/initializers.code.txt` | `test/markup/cpp/initializers.txt` |
| `cpp/number-literals.code.txt` | `test/markup/cpp/number-literals.txt` |
| `cpp/pointers-returns.code.txt` | `test/markup/cpp/pointers-returns.txt` |
| `cpp/preprocessor.code.txt` | `test/markup/cpp/preprocessor.txt` |
| `cpp/primitive-types.code.txt` | `test/markup/cpp/primitive-types.txt` |
| `cpp/string-literals.code.txt` | `test/markup/cpp/string-literals.txt` |
| `cpp/template-complexity.code.txt` | `test/markup/cpp/template-complexity.txt` |
| `cpp/truncated-raw-string.code.txt` | `test/markup/cpp/truncated-raw-string.txt` |
| `csharp/detect-sample.code.txt` | `test/detect/csharp/default.txt` |
| `csharp/dotted-namespace.code.txt` | `test/markup/csharp/dotted-namespace.txt` |
| `csharp/floats.code.txt` | Similar, not byte-identical: `test/markup/csharp/floats.txt` (similarity 0.869); attribution unconfirmed |
| `csharp/functions.code.txt` | `test/markup/csharp/functions.txt` |
| `csharp/generic_modifiers.code.txt` | `test/markup/csharp/generic_modifiers.txt` |
| `csharp/identifiers.code.txt` | `test/markup/csharp/identifiers.txt` |
| `csharp/records.code.txt` | `test/markup/csharp/records.txt` |
| `csharp/scoped.code.txt` | `test/markup/csharp/scoped.txt` |
| `csharp/string-interpolation.code.txt` | `test/markup/csharp/string-interpolation.txt` |
| `csharp/string-raw.code.txt` | `test/markup/csharp/string-raw.txt` |
| `csharp/titles.code.txt` | `test/markup/csharp/titles.txt` |
| `csharp/try-catch.code.txt` | `test/markup/csharp/try-catch.txt` |
| `css/css_consistency.code.txt` | Similar, not byte-identical: `test/markup/css/css_consistency.txt` (similarity 0.998); attribution unconfirmed |
| `css/detect-sample.code.txt` | `test/detect/css/default.txt` |
| `css/hex-colors.code.txt` | `test/markup/css/hex-colors.txt` |
| `css/pseudo-selector.code.txt` | `test/markup/css/pseudo-selector.txt` |
| `css/pseudo.code.txt` | `test/markup/css/pseudo.txt` |
| `css/sample.code.txt` | `test/markup/css/sample.txt` |
| `css/url.code.txt` | `test/markup/css/url.txt` |
| `css/variables.code.txt` | `test/markup/css/variables.txt` |
| `dart/comment-markdown.code.txt` | `test/markup/dart/comment-markdown.txt` |
| `dart/detect-sample.code.txt` | `test/detect/dart/default.txt` |
| `dart/string-interpolation.code.txt` | `test/markup/dart/string-interpolation.txt` |
| `delphi/character-string.code.txt` | `test/markup/delphi/character-string.txt` |
| `delphi/compiler-directive.code.txt` | `test/markup/delphi/compiler-directive.txt` |
| `delphi/detect-sample.code.txt` | `test/detect/delphi/default.txt` |
| `delphi/numeric-literal.code.txt` | `test/markup/delphi/numeric-literal.txt` |
| `diff/comments.code.txt` | `test/markup/diff/comments.txt` |
| `diff/detect-sample.code.txt` | `test/detect/diff/default.txt` |
| `diff/git-format-patch.code.txt` | Upstream fixture is an exact prefix: `test/markup/diff/git-format-patch.txt`; appended content and attribution unconfirmed |
| `dockerfile/default.code.txt` | `test/markup/dockerfile/default.txt` |
| `dockerfile/detect-sample.code.txt` | `test/detect/dockerfile/default.txt` |
| `dos/comments.code.txt` | `test/markup/dos/comments.txt` |
| `dos/detect-sample.code.txt` | `test/detect/dos/default.txt` |
| `elm/default.code.txt` | `test/markup/elm/default.txt`, `test/detect/elm/default.txt` |
| `elm/detect-sample.code.txt` | `test/markup/elm/default.txt`, `test/detect/elm/default.txt` |
| `erlang/char_literal.code.txt` | `test/markup/erlang/char_literal.txt` |
| `erlang/detect-sample.code.txt` | `test/detect/erlang/default.txt` |
| `erlang/doc_attribute.code.txt` | `test/markup/erlang/doc_attribute.txt` |
| `erlang/maybe.code.txt` | `test/markup/erlang/maybe.txt` |
| `erlang/numbers.code.txt` | `test/markup/erlang/numbers.txt` |
| `erlang/sigil.code.txt` | `test/markup/erlang/sigil.txt` |
| `erlang/triple_quote_string.code.txt` | `test/markup/erlang/triple_quote_string.txt` |
| `fortran/comments.code.txt` | `test/markup/fortran/comments.txt` |
| `fortran/detect-sample.code.txt` | `test/detect/fortran/default.txt` |
| `fortran/dot_keywords.code.txt` | `test/markup/fortran/dot_keywords.txt` |
| `fortran/numbers.code.txt` | `test/markup/fortran/numbers.txt` |
| `fsharp/attributes.code.txt` | `test/markup/fsharp/attributes.txt` |
| `fsharp/bang-keywords.code.txt` | `test/markup/fsharp/bang-keywords.txt` |
| `fsharp/comments.code.txt` | `test/markup/fsharp/comments.txt` |
| `fsharp/computation-expressions.code.txt` | `test/markup/fsharp/computation-expressions.txt` |
| `fsharp/detect-sample.code.txt` | `test/detect/fsharp/default.txt` |
| `fsharp/fsi-and-preprocessor.code.txt` | `test/markup/fsharp/fsi-and-preprocessor.txt` |
| `fsharp/numbers.code.txt` | `test/markup/fsharp/numbers.txt` |
| `fsharp/operators.code.txt` | `test/markup/fsharp/operators.txt` |
| `fsharp/strings.code.txt` | `test/markup/fsharp/strings.txt` |
| `fsharp/types.code.txt` | `test/markup/fsharp/types.txt` |
| `go/detect-sample.code.txt` | `test/detect/go/default.txt` |
| `go/functions.code.txt` | `test/markup/go/functions.txt` |
| `go/numbers.code.txt` | Similar, not byte-identical: `test/markup/go/numbers.txt` (similarity 0.978); attribution unconfirmed |
| `go/strings.code.txt` | `test/markup/go/strings.txt` |
| `groovy/default.code.txt` | `test/markup/groovy/default.txt` |
| `groovy/detect-sample.code.txt` | `test/detect/groovy/default.txt` |
| `groovy/numbers.code.txt` | Byte-identical to `test/markup/groovy/numbers.txt` at later highlight.js commit `8b5018a3883ebf3cd22c11353daced3938544d0e` |
| `groovy/oneoffs.code.txt` | `test/markup/groovy/oneoffs.txt` |
| `haskell/char.code.txt` | `test/markup/haskell/char.txt` |
| `haskell/detect-sample.code.txt` | `test/detect/haskell/default.txt` |
| `haskell/infix.code.txt` | `test/markup/haskell/infix.txt` |
| `haskell/inline-comments.code.txt` | `test/markup/haskell/inline-comments.txt` |
| `haskell/nested-comments.code.txt` | `test/markup/haskell/nested-comments.txt` |
| `haskell/numbers.code.txt` | `test/markup/haskell/numbers.txt` |
| `http/default.code.txt` | `test/markup/http/default.txt` |
| `http/detect-sample.code.txt` | `test/detect/http/default.txt` |
| `http/http3.code.txt` | `test/markup/http/http3.txt` |
| `http/just_headers.code.txt` | `test/markup/http/just_headers.txt` |
| `http/response.code.txt` | `test/markup/http/response.txt` |
| `ini/array.code.txt` | `test/markup/ini/array.txt` |
| `ini/comments.code.txt` | `test/markup/ini/comments.txt` |
| `ini/detect-sample.code.txt` | `test/detect/ini/default.txt` |
| `ini/keys.code.txt` | `test/markup/ini/keys.txt` |
| `ini/tables.code.txt` | `test/markup/ini/tables.txt` |
| `ini/types.code.txt` | `test/markup/ini/types.txt` |
| `ini/variable.code.txt` | `test/markup/ini/variable.txt` |
| `java/annotations.code.txt` | `test/markup/java/annotations.txt` |
| `java/bugs.code.txt` | `test/markup/java/bugs.txt` |
| `java/detect-sample.code.txt` | `test/detect/java/default.txt` |
| `java/functions.code.txt` | `test/markup/java/functions.txt` |
| `java/gh1031.code.txt` | `test/markup/java/gh1031.txt` |
| `java/numbers.code.txt` | `test/markup/java/numbers.txt` |
| `java/switch.code.txt` | `test/markup/java/switch.txt` |
| `java/textblock.code.txt` | `test/markup/java/textblock.txt` |
| `java/titles.code.txt` | `test/markup/java/titles.txt` |
| `javascript/arrow-function.code.txt` | `test/markup/javascript/arrow-function.txt` |
| `javascript/block-comments.code.txt` | `test/markup/javascript/block-comments.txt` |
| `javascript/built-in.code.txt` | `test/markup/javascript/built-in.txt` |
| `javascript/class.code.txt` | `test/markup/javascript/class.txt` |
| `javascript/comments.code.txt` | `test/markup/javascript/comments.txt` |
| `javascript/conventions.code.txt` | `test/markup/javascript/conventions.txt` |
| `javascript/default-parameters.code.txt` | `test/markup/javascript/default-parameters.txt` |
| `javascript/detect-sample.code.txt` | `test/detect/javascript/default.txt` |
| `javascript/inline-languages.code.txt` | `test/markup/javascript/inline-languages.txt` |
| `javascript/jsdoc.code.txt` | `test/markup/javascript/jsdoc.txt` |
| `javascript/jsx-fragment.code.txt` | `test/markup/javascript/jsx-fragment.txt` |
| `javascript/jsx.code.txt` | `test/markup/javascript/jsx.txt` |
| `javascript/keyword-as-part-of-method-name.code.txt` | `test/markup/javascript/keyword-as-part-of-method-name.txt` |
| `javascript/keyword_as_identifier.code.txt` | `test/markup/javascript/keyword_as_identifier.txt` |
| `javascript/keywords.code.txt` | Similar, not byte-identical: `test/markup/javascript/keywords.txt` (similarity 0.921); attribution unconfirmed |
| `javascript/method-call.code.txt` | `test/markup/javascript/method-call.txt` |
| `javascript/modules.code.txt` | `test/markup/javascript/modules.txt` |
| `javascript/numbers.code.txt` | `test/markup/javascript/numbers.txt` |
| `javascript/object-attr.code.txt` | `test/markup/javascript/object-attr.txt` |
| `javascript/regex.code.txt` | `test/markup/javascript/regex.txt` |
| `javascript/seperated-parameters.code.txt` | `test/markup/javascript/seperated-parameters.txt` |
| `javascript/shebang.code.txt` | `test/markup/javascript/shebang.txt` |
| `javascript/template-strings.code.txt` | `test/markup/javascript/template-strings.txt` |
| `json/comments.code.txt` | `test/markup/json/comments.txt` |
| `json/detect-sample.code.txt` | `test/detect/json/default.txt` |
| `kotlin/class.code.txt` | `test/markup/kotlin/class.txt` |
| `kotlin/detect-sample.code.txt` | `test/detect/kotlin/default.txt` |
| `kotlin/function.code.txt` | `test/markup/kotlin/function.txt` |
| `kotlin/nested_comment.code.txt` | `test/markup/kotlin/nested_comment.txt` |
| `kotlin/string.code.txt` | `test/markup/kotlin/string.txt` |
| `leaf/default.code.txt` | Similar, not byte-identical: `test/markup/leaf/default.txt` (similarity 0.990); attribution unconfirmed |
| `leaf/detect-sample.code.txt` | `test/markup/leaf/default.txt`, `test/detect/leaf/default.txt` |
| `less/css_consistency.code.txt` | Similar, not byte-identical: `test/markup/less/css_consistency.txt` (similarity 0.998); attribution unconfirmed |
| `less/detect-sample.code.txt` | `test/detect/less/default.txt` |
| `less/selectors.code.txt` | `test/markup/less/selectors.txt` |
| `lisp/detect-sample.code.txt` | `test/detect/lisp/default.txt` |
| `lisp/mec.code.txt` | `test/markup/lisp/mec.txt` |
| `llvm/default.code.txt` | `test/markup/llvm/default.txt`, `test/detect/llvm/default.txt` |
| `llvm/detect-sample.code.txt` | `test/markup/llvm/default.txt`, `test/detect/llvm/default.txt` |
| `llvm/numbers.code.txt` | `test/markup/llvm/numbers.txt` |
| `llvm/simple.code.txt` | `test/markup/llvm/simple.txt` |
| `llvm/string.code.txt` | `test/markup/llvm/string.txt` |
| `lua/default.code.txt` | `test/markup/lua/default.txt`, `test/detect/lua/default.txt` |
| `lua/detect-sample.code.txt` | `test/markup/lua/default.txt`, `test/detect/lua/default.txt` |
| `makefile/default.code.txt` | `test/markup/makefile/default.txt`, `test/detect/makefile/default.txt` |
| `makefile/detect-sample.code.txt` | `test/markup/makefile/default.txt`, `test/detect/makefile/default.txt` |
| `markdown/bold_italics.code.txt` | `test/markup/markdown/bold_italics.txt` |
| `markdown/code.code.txt` | `test/markup/markdown/code.txt` |
| `markdown/detect-sample.code.txt` | `test/detect/markdown/default.txt` |
| `markdown/entity.code.txt` | `test/markup/markdown/entity.txt` |
| `markdown/links.code.txt` | `test/markup/markdown/links.txt` |
| `markdown/list.code.txt` | `test/markup/markdown/list.txt` |
| `markdown/sections.code.txt` | `test/markup/markdown/sections.txt` |
| `matlab/block_comment.code.txt` | `test/markup/matlab/block_comment.txt` |
| `matlab/detect-sample.code.txt` | `test/detect/matlab/default.txt` |
| `matlab/transpose.code.txt` | `test/markup/matlab/transpose.txt` |
| `nginx/default.code.txt` | `test/markup/nginx/default.txt`, `test/detect/nginx/default.txt` |
| `nginx/detect-sample.code.txt` | `test/markup/nginx/default.txt`, `test/detect/nginx/default.txt` |
| `nim/default.code.txt` | `test/markup/nim/default.txt`, `test/detect/nim/default.txt` |
| `nim/detect-sample.code.txt` | `test/markup/nim/default.txt`, `test/detect/nim/default.txt` |
| `nix/default.code.txt` | `test/markup/nix/default.txt` |
| `nix/detect-sample.code.txt` | `test/detect/nix/default.txt` |
| `objectivec/detect-sample.code.txt` | `test/detect/objectivec/default.txt` |
| `objectivec/preprocessor.code.txt` | `test/markup/objectivec/preprocessor.txt` |
| `objectivec/string-literals.code.txt` | `test/markup/objectivec/string-literals.txt` |
| `ocaml/detect-sample.code.txt` | `test/detect/ocaml/default.txt` |
| `ocaml/literals.code.txt` | `test/markup/ocaml/literals.txt` |
| `ocaml/types.code.txt` | `test/markup/ocaml/types.txt` |
| `perl/class.code.txt` | `test/markup/perl/class.txt` |
| `perl/default.code.txt` | `test/markup/perl/default.txt` |
| `perl/detect-sample.code.txt` | `test/detect/perl/default.txt` |
| `perl/number.code.txt` | `test/markup/perl/number.txt` |
| `perl/regex.code.txt` | `test/markup/perl/regex.txt` |
| `php/attributes.code.txt` | Similar, not byte-identical: `test/markup/php/attributes.txt` (similarity 0.963); attribution unconfirmed |
| `php/case.code.txt` | `test/markup/php/case.txt` |
| `php/comments.code.txt` | `test/markup/php/comments.txt` |
| `php/detect-sample.code.txt` | `test/detect/php/default.txt` |
| `php/functions.code.txt` | Similar, not byte-identical: `test/markup/php/functions.txt` (similarity 0.881); attribution unconfirmed |
| `php/namespace.code.txt` | `test/markup/php/namespace.txt` |
| `php/numbers.code.txt` | `test/markup/php/numbers.txt` |
| `php/php80.code.txt` | `test/markup/php/php80.txt` |
| `php/strings.code.txt` | `test/markup/php/strings.txt` |
| `php/titles.code.txt` | `test/markup/php/titles.txt` |
| `plaintext/default.code.txt` | `test/markup/plaintext/default.txt`, `test/markup/plaintext/default.expect.txt`, `test/detect/plaintext/default.txt` |
| `plaintext/detect-sample.code.txt` | `test/markup/plaintext/default.txt`, `test/markup/plaintext/default.expect.txt`, `test/detect/plaintext/default.txt` |
| `powershell/apos-herestring.code.txt` | `test/markup/powershell/apos-herestring.txt` |
| `powershell/classes.code.txt` | `test/markup/powershell/classes.txt` |
| `powershell/detect-sample.code.txt` | `test/detect/powershell/default.txt` |
| `powershell/flags.code.txt` | `test/markup/powershell/flags.txt` |
| `powershell/misc.code.txt` | `test/markup/powershell/misc.txt` |
| `powershell/quote-herestring.code.txt` | `test/markup/powershell/quote-herestring.txt` |
| `prolog/default.code.txt` | `test/markup/prolog/default.txt`, `test/detect/prolog/default.txt` |
| `prolog/detect-sample.code.txt` | `test/markup/prolog/default.txt`, `test/detect/prolog/default.txt` |
| `properties/detect-sample.code.txt` | `test/detect/properties/default.txt` |
| `properties/syntax.code.txt` | `test/markup/properties/syntax.txt` |
| `python/class_self.code.txt` | `test/markup/python/class_self.txt` |
| `python/decorators.code.txt` | `test/markup/python/decorators.txt` |
| `python/detect-sample.code.txt` | `test/detect/python/default.txt` |
| `python/diacritic_identifiers.code.txt` | `test/markup/python/diacritic_identifiers.txt` |
| `python/escaped-quotes.code.txt` | `test/markup/python/escaped-quotes.txt` |
| `python/f-strings.code.txt` | `test/markup/python/f-strings.txt` |
| `python/false_positives.code.txt` | `test/markup/python/false_positives.expect.txt`, `test/markup/python/false_positives.txt` |
| `python/function-header-comments.code.txt` | `test/markup/python/function-header-comments.txt` |
| `python/function-header.code.txt` | `test/markup/python/function-header.txt` |
| `python/identifiers.code.txt` | `test/markup/python/identifiers.txt` |
| `python/keywords.code.txt` | `test/markup/python/keywords.txt` |
| `python/lazy-import.code.txt` | Byte-identical to `test/markup/python/lazy-import.txt` at later highlight.js commit `40fc89efb14216a8e491f83ba543e276b18af842` |
| `python/matrix-multiplication.code.txt` | `test/markup/python/matrix-multiplication.txt` |
| `python/numbers.code.txt` | `test/markup/python/numbers.txt` |
| `r/detect-sample.code.txt` | `test/detect/r/default.txt` |
| `r/names.code.txt` | `test/markup/r/names.txt` |
| `r/numbers.code.txt` | `test/markup/r/numbers.txt` |
| `r/roxygen.code.txt` | `test/markup/r/roxygen.txt` |
| `r/strings.code.txt` | `test/markup/r/strings.txt` |
| `ruby/blocks.code.txt` | `test/markup/ruby/blocks.txt` |
| `ruby/detect-sample.code.txt` | `test/detect/ruby/default.txt` |
| `ruby/gemfile.code.txt` | `test/markup/ruby/gemfile.txt` |
| `ruby/heredoc.code.txt` | `test/markup/ruby/heredoc.txt` |
| `ruby/numbers.code.txt` | `test/markup/ruby/numbers.txt` |
| `ruby/prompt.code.txt` | `test/markup/ruby/prompt.txt` |
| `ruby/regexes.code.txt` | `test/markup/ruby/regexes.txt` |
| `ruby/strings.code.txt` | `test/markup/ruby/strings.txt` |
| `rust/comments.code.txt` | `test/markup/rust/comments.txt` |
| `rust/detect-sample.code.txt` | `test/detect/rust/default.txt` |
| `rust/extern.code.txt` | Byte-identical to `test/markup/rust/extern.txt` at later highlight.js commit `5478eb8a6b54306a7c81f75158f814ccc2eef214` |
| `rust/invoked-keywords.code.txt` | `test/markup/rust/invoked-keywords.txt` |
| `rust/numbers.code.txt` | Similar, not byte-identical: `test/markup/rust/numbers.txt` (similarity 0.921); attribution unconfirmed |
| `rust/sample1.code.txt` | Similar, not byte-identical: `test/markup/rust/sample1.txt` (similarity 0.984); attribution unconfirmed |
| `rust/strings.code.txt` | `test/markup/rust/strings.txt` |
| `rust/traits.code.txt` | `test/markup/rust/traits.txt` |
| `rust/types.code.txt` | `test/markup/rust/types.txt` |
| `rust/variables.code.txt` | `test/markup/rust/variables.txt` |
| `scala/case-classes.code.txt` | `test/markup/scala/case-classes.txt` |
| `scala/detect-sample.code.txt` | `test/detect/scala/default.txt` |
| `scala/end.code.txt` | `test/markup/scala/end.txt` |
| `scala/enum.code.txt` | `test/markup/scala/enum.txt` |
| `scala/export.code.txt` | `test/markup/scala/export.txt` |
| `scala/extension.code.txt` | `test/markup/scala/extension.txt` |
| `scala/for-do.code.txt` | `test/markup/scala/for-do.txt` |
| `scala/given.code.txt` | `test/markup/scala/given.txt` |
| `scala/if-then-else.code.txt` | `test/markup/scala/if-then-else.txt` |
| `scala/inline.code.txt` | `test/markup/scala/inline.txt` |
| `scala/quoted-code.code.txt` | `test/markup/scala/quoted-code.txt` |
| `scala/strings.code.txt` | `test/markup/scala/strings.txt` |
| `scala/symbol.code.txt` | `test/markup/scala/symbol.txt` |
| `scala/transparent.code.txt` | `test/markup/scala/transparent.txt` |
| `scala/using-directives.code.txt` | `test/markup/scala/using-directives.txt` |
| `scala/using.code.txt` | `test/markup/scala/using.txt` |
| `scala/while-do.code.txt` | `test/markup/scala/while-do.txt` |
| `scheme/detect-sample.code.txt` | `test/detect/scheme/default.txt` |
| `scheme/lambda.code.txt` | `test/markup/scheme/lambda.txt` |
| `scheme/quoted.code.txt` | `test/markup/scheme/quoted.txt` |
| `scss/css_consistency.code.txt` | Similar, not byte-identical: `test/markup/scss/css_consistency.txt` (similarity 0.998); attribution unconfirmed |
| `scss/default.code.txt` | `test/markup/scss/default.txt`, `test/detect/scss/default.txt` |
| `scss/detect-sample.code.txt` | `test/markup/scss/default.txt`, `test/detect/scss/default.txt` |
| `shell/command-continuation.code.txt` | `test/markup/shell/command-continuation.txt` |
| `shell/detect-sample.code.txt` | `test/detect/shell/default.txt` |
| `shell/plain-prompt.code.txt` | `test/markup/shell/plain-prompt.txt` |
| `shell/prompt-with-period.code.txt` | Byte-identical to `test/markup/shell/prompt-with-period.txt` at later highlight.js commit `5116e879ddbc528ab698185cac64456a3da60014` |
| `shell/prompt-with-slash.code.txt` | `test/markup/shell/prompt-with-slash.txt` |
| `shell/prompt-with-tilde.code.txt` | `test/markup/shell/prompt-with-tilde.txt` |
| `shell/simple.code.txt` | `test/markup/shell/simple.txt` |
| `shell/single.code.txt` | `test/markup/shell/single.txt` |
| `sql/combos.code.txt` | `test/markup/sql/combos.txt` |
| `sql/detect-sample.code.txt` | `test/detect/sql/default.txt` |
| `sql/functions.code.txt` | `test/markup/sql/functions.txt` |
| `sql/join.code.txt` | `test/markup/sql/join.txt` |
| `sql/keywords.code.txt` | `test/markup/sql/keywords.txt` |
| `sql/numeric-types.code.txt` | `test/markup/sql/numeric-types.txt` |
| `sql/set-operator.code.txt` | `test/markup/sql/set-operator.txt` |
| `sql/string-types.code.txt` | `test/markup/sql/string-types.txt` |
| `sql/types.code.txt` | `test/markup/sql/types.txt` |
| `sql/values-statement.code.txt` | `test/markup/sql/values-statement.txt` |
| `stylus/css_consistency.code.txt` | Similar, not byte-identical: `test/markup/stylus/css_consistency.txt` (similarity 0.998); attribution unconfirmed |
| `stylus/default.code.txt` | `test/markup/stylus/default.txt`, `test/detect/stylus/default.txt` |
| `stylus/detect-sample.code.txt` | `test/markup/stylus/default.txt`, `test/detect/stylus/default.txt` |
| `swift/attributes.code.txt` | `test/markup/swift/attributes.txt` |
| `swift/availability.code.txt` | `test/markup/swift/availability.txt` |
| `swift/class-func-var.code.txt` | `test/markup/swift/class-func-var.txt` |
| `swift/detect-sample.code.txt` | `test/detect/swift/default.txt` |
| `swift/distributed-actor-runtime.code.txt` | `test/markup/swift/distributed-actor-runtime.txt` |
| `swift/functions.code.txt` | `test/markup/swift/functions.txt` |
| `swift/identifiers.code.txt` | `test/markup/swift/identifiers.txt` |
| `swift/keywords.code.txt` | `test/markup/swift/keywords.txt` |
| `swift/macro.code.txt` | `test/markup/swift/macro.txt` |
| `swift/numbers.code.txt` | `test/markup/swift/numbers.txt` |
| `swift/operator-declarations.code.txt` | `test/markup/swift/operator-declarations.txt` |
| `swift/operators.code.txt` | `test/markup/swift/operators.txt` |
| `swift/ownership.code.txt` | `test/markup/swift/ownership.txt` |
| `swift/parameterpack.code.txt` | `test/markup/swift/parameterpack.txt` |
| `swift/precedencegroup.code.txt` | `test/markup/swift/precedencegroup.txt` |
| `swift/regex.code.txt` | `test/markup/swift/regex.txt` |
| `swift/strings.code.txt` | `test/markup/swift/strings.txt` |
| `swift/swiftui.code.txt` | `test/markup/swift/swiftui.txt` |
| `swift/tuples.code.txt` | `test/markup/swift/tuples.txt` |
| `swift/type-definition.code.txt` | `test/markup/swift/type-definition.txt` |
| `swift/types.code.txt` | `test/markup/swift/types.txt` |
| `typescript/class.code.txt` | `test/markup/typescript/class.txt` |
| `typescript/declares.code.txt` | `test/markup/typescript/declares.txt` |
| `typescript/decorator-factories.code.txt` | `test/markup/typescript/decorator-factories.txt` |
| `typescript/detect-sample.code.txt` | `test/detect/typescript/default.txt` |
| `typescript/functions.code.txt` | `test/markup/typescript/functions.txt` |
| `typescript/generics.code.txt` | `test/markup/typescript/generics.txt` |
| `typescript/identifiers_that_include_keywords.code.txt` | `test/markup/typescript/identifiers_that_include_keywords.txt` |
| `typescript/inline-languages.code.txt` | `test/markup/typescript/inline-languages.txt` |
| `typescript/jsx.code.txt` | `test/markup/typescript/jsx.txt` |
| `typescript/module-id.code.txt` | `test/markup/typescript/module-id.txt` |
| `typescript/namespace_as_identifier.code.txt` | `test/markup/typescript/namespace_as_identifier.txt` |
| `typescript/nested-templates.code.txt` | `test/markup/typescript/nested-templates.txt` |
| `typescript/numbers-and-dashes.code.txt` | `test/markup/typescript/numbers-and-dashes.txt` |
| `typescript/numbers.code.txt` | `test/markup/typescript/numbers.txt` |
| `typescript/satisfies-and-as.code.txt` | `test/markup/typescript/satisfies-and-as.txt` |
| `vim/default.code.txt` | `test/markup/vim/default.txt`, `test/detect/vim/default.txt` |
| `vim/detect-sample.code.txt` | `test/markup/vim/default.txt`, `test/detect/vim/default.txt` |
| `vim/strings-comments.code.txt` | `test/markup/vim/strings-comments.txt` |
| `xml/detect-sample.code.txt` | `test/detect/xml/default.txt` |
| `xml/document-type-variations.code.txt` | `test/markup/xml/document-type-variations.txt` |
| `xml/namespace.code.txt` | `test/markup/xml/namespace.txt` |
| `xml/non-ascii-attribute-names.code.txt` | Similar, not byte-identical: `test/markup/xml/non-ascii-attribute-names.txt` (similarity 0.997); attribution unconfirmed |
| `xml/non-ascii-element-names.code.txt` | Similar, not byte-identical: `test/markup/xml/non-ascii-element-names.txt` (similarity 0.999); attribution unconfirmed |
| `xml/processing.code.txt` | `test/markup/xml/processing.txt` |
| `xml/space-attributes.code.txt` | `test/markup/xml/space-attributes.txt` |
| `xml/sublanguage_no_relevancy.code.txt` | `test/markup/xml/sublanguage_no_relevancy.txt` |
| `xml/unquoted-attributes.code.txt` | `test/markup/xml/unquoted-attributes.txt` |
| `yaml/block.code.txt` | `test/markup/yaml/block.txt` |
| `yaml/detect-sample.code.txt` | `test/detect/yaml/default.txt` |
| `yaml/inline.code.txt` | `test/markup/yaml/inline.txt` |
| `yaml/keys.code.txt` | `test/markup/yaml/keys.txt` |
| `yaml/numbers.code.txt` | `test/markup/yaml/numbers.txt` |
| `yaml/special_chars.code.txt` | `test/markup/yaml/special_chars.txt` |
| `yaml/string.code.txt` | `test/markup/yaml/string.txt` |
| `yaml/tag.code.txt` | `test/markup/yaml/tag.txt` |

The four fixtures above are absent from the pinned 11.11.1 tree but are
byte-identical to files in the later highlight.js commits shown. The root
BSD-3-Clause license at each of those commits is identical to the license in
`Licenses/highlight.js-BSD-3-Clause.txt`. All four were also present in
HighlightKit's initial commit `b6c89dd5012d16a2d2dba44a2df758b474e81a59`.
Byte identity establishes a match, not independent verification of all rights
in the original contribution.
