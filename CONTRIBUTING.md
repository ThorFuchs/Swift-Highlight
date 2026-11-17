# Contributing to Swift-Highlight

Start with a focused issue or a reproducible example. Open a pull request against
the project's default branch once your change is ready for review. The project
is maintained by [Thorsten Fuchs](https://github.com/ThorFuchs).

## Set up

Use Swift 6.1 or later. The package has no external Swift package dependencies;
Foundation's regular expressions and `Synchronization` come from the selected
Swift toolchain and platform. Apple rendering requires an Apple SDK. For WASI,
use a Swift.org toolchain and SDK of the same release. The
[implementation report](Documentation/IMPLEMENTATION-REPORT.md) records what
has actually been tested.

```sh
git clone https://github.com/ThorFuchs/Swift-Highlight.git
cd Swift-Highlight
swift build
swift test
```

During release preparation, access to the private repository is required to
clone it. Check the available tags and default branch before relying on them.

## Make a change

- Keep the `SwiftHighlight`, `SwiftHighlightHTML`, and `SwiftHighlightApple`
  boundaries. Core must not depend on Apple UI frameworks or a renderer.
- Add a focused regression test when behavior changes. Preserve UTF-16 source
  ranges, plain-text gaps, strict diagnostics, and safe HTML escaping.
- Document public APIs and meaningful behavior changes. Add user-visible changes
  to the `Unreleased` section of [CHANGELOG.md](CHANGELOG.md).
- Do not rewrite fixture inputs or expected tokens to hide a failure. Check the
  pinned reference and document intentional differences.
- For performance work, report the workload, command, toolchain, environment,
  baseline, and candidate measurements. The retained upstream benchmark notes
  are historical context, not measurements of your change.

## Verify

```sh
swift build
swift test
swift build -c release
python3 Tools/check-documentation-links.py
python3 -m unittest discover -s Tools -p 'test_*.py'
sh Tools/build-docc.sh
```

DocC needs Python 3 and a `docc` executable from the selected Swift toolchain.
The documentation script checks public symbol comments for available modules;
on Linux it reports that Apple DocC is skipped because Apple SDK symbols are
unavailable. Validate the Apple archive on an Apple toolchain separately. On
macOS the script also builds the test targets in its scratch directory before
extracting symbol graphs; it does not run the tests.

The fixture inventory asserts 375 code/expectation pairs across 65 languages;
the parameterized fidelity test compares tokens and relevance. For grammar and
engine changes, also follow [Scripts/README.md](Scripts/README.md) to build the
pinned highlight.js reference and run `Scripts/verify-fixtures.py` and relevant
differential checks. The verifier does not overwrite checked-in expectations.

The [WASI smoke example](Examples/WASISmoke/README.md) demonstrates a separate
consumer. Apple-specific changes require the relevant Apple SDK checks. Linux
Thread Sanitizer currently reports warnings even in a minimal `Mutex` control;
that observation does not prove a package warning harmless. Report actual
commands, failures, and unavailable checks in the pull request.

## Licensing and conduct

New contributions are offered under [Apache-2.0](LICENSE). Preserve existing
MIT/BSD notices, file headers and attribution; see [NOTICE](NOTICE) and
[third-party notices](THIRD_PARTY_NOTICES.md). For new third-party material,
record its source, revision, license and any required notices.

Follow [community standards](CODE_OF_CONDUCT.md). Report security issues
privately as described in [SECURITY.md](SECURITY.md).
