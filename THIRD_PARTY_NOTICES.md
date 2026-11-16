# Third-party notices

Swift-Highlight contains HighlightKit by Phrase (MIT), revision
`524c185b0553756498c1b6a1765e8d119c4623a6`. The complete original
license is in `Licenses/HighlightKit-MIT.txt`. HighlightKit ports
highlight.js 11.11.1, commit `08cb242e7d4aee787114eb04cc7ab18314d82f92`.
Its engine semantics, language grammars, fixtures and GitHub themes derive
from highlight.js. Its full BSD-3-Clause license is in
`Licenses/highlight.js-BSD-3-Clause.txt`. The Xcode themes originated in
HighlightKit; adaptive variants remain included. Both notices and license
texts must accompany source and binary distributions. The Apache-2.0 root
license applies to new project contributions, not as a replacement for the
licenses of imported material.

The fixture corpus is imported unchanged from HighlightKit. Its individual
provenance has not been independently audited: in particular
`Tests/HighlightKitTests/Fixtures/xml/document-type-variations.code.txt`
contains a Walt Disney Company copyright string. Before distribution, review
individual fixtures and any additional upstream notices; this document does
not assert that such an audit is complete.
