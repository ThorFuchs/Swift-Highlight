# Changelog

## Unreleased

## 1.0.2

- Expand DocC API guidance and add verified examples for language detection,
  incremental highlighting, custom grammars, HTML, and Apple themes.
- Add a Swift Package Index documentation configuration for all three library
  products and check documentation examples in continuous integration.

## 1.0.1

- Replace identified literary quotations and a named example in three test
  fixtures with neutral text, preserving reference-checked syntax coverage.
- Use NSLock-protected registry state on Linux so targeted concurrency paths can
  be checked by Thread Sanitizer; record the measured contention trade-off.
- Add repeated Linux Thread Sanitizer checks and document fixture provenance,
  historical limitations, and the 1.0.0 release status.

## 1.0.0

- Import the HighlightKit history and the pinned highlight.js-derived catalog.
- Separate the Swift core, safe HTML output, and Apple attributed-text output.
- Add strict diagnostics, source-bound tokens, and UTF-16 range validation.
- Add WASI Preview 1 consumer smoke coverage and reproducible fixture checks.
- Provide DocC documentation, contribution guidance, and release checks.

Historical HighlightKit release notes are preserved in
[the upstream changelog](Documentation/UPSTREAM-CHANGELOG.md).
