# Language showcase

The [samples](Samples/) are original, small examples written for this project.
They illustrate ten supported languages; they are not exhaustive compatibility
tests. The checked-in PNGs in [Images](Images/) show their actual output from
Swift-Highlight's strict highlighter and `SwiftHighlightApple`'s `githubDark`
theme. The HTML example uses the registered `xml` grammar, which also has the
`html` alias. The header and separator are added by the showcase generator.

## Regenerate the gallery

On macOS 15 or later with a Swift 6.1 or later toolchain and an Apple SDK, run
from the repository root:

```sh
swift run --package-path Examples/Showcase ShowcaseGenerator \
  Examples/Showcase/Samples Examples/Showcase/Images
```

The generator reads each source file, highlights it with the explicit language,
applies the theme, and writes a 2× PNG. It rejects empty token results and source
lines that do not fit the card. Review the regenerated images after changing a
sample or the highlighter: font rendering can vary by macOS and toolchain.
The macOS CI job also runs the generator against all ten samples.

The generator depends on the local checkout, not a released package, and does
not require third-party Swift packages. For the independent SwiftPM consumer
example, see [WASI smoke](../WASISmoke/README.md).
