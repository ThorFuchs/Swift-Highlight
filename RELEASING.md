# Release process

The proposed initial version is `1.0.0`; it is **not yet published**. Use
semantic version tags without a `v` prefix, consistent with Swift-GFM. Never
move or delete a published tag. Creating a tag, pushing it, publishing a GitHub
release, and changing repository visibility are distinct maintainer actions.

## Current release checks

- Neither the local repository nor `origin` had a `1.0.0` tag when checked.
  Imported HighlightKit tags `0.1.0`, `0.1.1`, and `0.2.0` refer to upstream
  commits, not Swift-Highlight releases. Keep them for provenance; do not use
  `git push --tags` or move an existing remote tag. Push the chosen tag only.
- Review the [fixture provenance inventory](Documentation/FIXTURE-PROVENANCE.md)
  and third-party notices, including quoted material and modified fixtures.
  Current documentation does not assert a completed rights audit.
- `origin/HEAD` selected `feature/bootstrap-swift-highlight` when checked
  during preparation. Decide whether to create and select `main` as the default
  branch, as in Swift-GFM, before publishing; do not assume it already exists.
- Confirm private vulnerability reporting is enabled and accessible before
  publication. Review Linux Thread Sanitizer warnings, verify remaining Apple
  SDK builds and tests on the intended release toolchains, and confirm CI for
  the exact release commit. The maintainer reported successful macOS DocC
  generation for all three archives at `cb3fb8c`. Distinguish user-reported
  results and WASI smoke coverage from a comprehensive platform test.

## Prepare and publish

1. Review the API and [versioning policy](README.md#versioning-and-support),
   changes, licenses, platform claims, and unresolved diagnostics.
2. Run the checks in [CONTRIBUTING.md](CONTRIBUTING.md), including the pinned
   fixture verification and relevant Apple and WASI checks. Inspect the actual
   CI outcome for the exact commit; configuration alone is not a pass.
3. Move `Unreleased` notes into a `1.0.0` section only when the release commit
   is agreed. Merge to the intended default branch through the normal review
   process.
4. Recheck local and remote tag names, then create an annotated `1.0.0` tag on
   the agreed release commit and push that tag only. Publish a GitHub release
   with [the draft release notes](Documentation/RELEASE-NOTES-1.0.0.md) after
   review and authorization. Do not move an existing remote tag.
5. From a separate consumer, resolve the published version through SwiftPM and
   build the applicable products. Verify documentation and release assets,
   including third-party notices for source and binary distributions.
