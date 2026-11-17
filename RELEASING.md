# Release process

Swift-Highlight uses semantic version tags without a `v` prefix. Version
[1.0.0](https://github.com/ThorFuchs/Swift-Highlight/releases/tag/1.0.0) was
published from commit `326a0085c05931b868f5bff084d51eca7584aad7`. Never move,
delete, or recreate a published tag.

Imported HighlightKit tags `0.1.0`, `0.1.1`, and `0.2.0` refer to upstream
commits, not Swift-Highlight releases. Keep them for provenance; do not use
`git push --tags`. Push only the intended new tag.

## Prepare and publish

1. Review the API and [versioning policy](README.md#versioning-and-support),
   changes, licenses, platform claims, and unresolved diagnostics. Review the
   [fixture provenance inventory](Documentation/FIXTURE-PROVENANCE.md) and
   third-party notices; provenance does not establish all rights in quoted
   material.
2. Run the checks in [CONTRIBUTING.md](CONTRIBUTING.md), including the pinned
   fixture verification and relevant Apple and WASI checks. Review outstanding
   sanitizer findings. Inspect the actual CI outcome for the exact release
   commit; configuration alone is not a pass. Distinguish simulator builds and
   WASI smoke coverage from comprehensive runtime tests.
3. Update the changelog and prepare release notes. Merge the agreed release
   commit to the intended default branch through the normal review process.
4. Check local and remote tags and verify the commit to release. Create an
   annotated tag for the new version and push that tag only. Publish a GitHub
   release using the reviewed notes and the existing tag. If the tag already
   exists, verify its target and never move or recreate it.
5. From a separate consumer, resolve the published version through SwiftPM and
   build the applicable products. Verify the release page, documentation and
   third-party notices for source and binary distributions.

The [1.0.0 release notes](Documentation/RELEASE-NOTES-1.0.0.md) provide an
example of the scope and limitations to record. The
[implementation report](Documentation/IMPLEMENTATION-REPORT.md) preserves
historical verification details and unresolved findings.
