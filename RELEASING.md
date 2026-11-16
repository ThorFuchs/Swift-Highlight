# Release process

The proposed initial version is `0.1.0`; it is **not yet published**. Use
semantic version tags without a `v` prefix, consistent with Swift-GFM. Never
move or delete a published tag. Creating a tag, pushing it, publishing a GitHub
release, and changing repository visibility are distinct maintainer actions.

## Current release blockers

- The imported HighlightKit history brought a local `0.1.0` tag that points to
  its initial commit `b6c89dd5012d16a2d2dba44a2df758b474e81a59`, not the
  Swift-Highlight release commit. The destination `origin` had no tags when
  checked during preparation. Preserve upstream tag provenance and resolve the
  local name collision before creating the project's tag; never force-push.
- Review the [fixture provenance inventory](Documentation/FIXTURE-PROVENANCE.md)
  and third-party notices, including quoted material and non-identical fixtures.
  Current documentation does not assert a completed rights audit.
- `origin/HEAD` selected `feature/bootstrap-swift-highlight` when checked
  during preparation. Decide whether to create and select `main` as the default
  branch, as in Swift-GFM, before publishing; do not assume it already exists.
- Confirm private vulnerability reporting is enabled and accessible before
  publication. Remove any remaining inherited contact or upstream product
  references from current project instructions.
- Review Linux Thread Sanitizer warnings, verify Apple SDK builds/tests and
  DocC on the intended release toolchains, and confirm CI for the exact release
  commit. Distinguish user-reported results and WASI smoke coverage from a
  comprehensive platform test.

## Prepare and publish

1. Review the API and [versioning policy](README.md#versioning-and-support),
   changes, licenses, platform claims, and unresolved diagnostics.
2. Run the checks in [CONTRIBUTING.md](CONTRIBUTING.md), including the pinned
   fixture verification and relevant Apple and WASI checks. Inspect the actual
   CI outcome for the exact commit; configuration alone is not a pass.
3. Move `Unreleased` notes into a `0.1.0` section only when the release commit
   is agreed. Merge to the intended default branch through the normal review
   process.
4. After resolving the local upstream-tag collision and rechecking the remote,
   create an annotated `0.1.0` tag on the agreed release commit and push it.
   Publish a GitHub release with the changelog as notes only when publication
   is authorized. Do not move an existing remote tag.
5. From a separate consumer, resolve the published version through SwiftPM and
   build the applicable products. Verify documentation and release assets,
   including third-party notices for source and binary distributions.
