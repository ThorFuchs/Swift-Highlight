# Concurrency and resource limits

Understand caching, continuation lifetime, and the limits of cancellation.

``Highlighter`` uses a synchronized registry and compiles grammars lazily.
Compiled graphs are kept alive by active runs and continuations; internal
`@unchecked Sendable` graph types rely on those ownership and synchronization
invariants. Linux CI checks selected contended compilation paths with Thread Sanitizer;
the independent standard-library `Mutex` control can still report warnings.
These targeted checks do not prove the entire package race-free; consult the
repository's implementation report for the measured scope and limitations.

Automatic detection may evaluate many grammars. Its async overload bounds
parallelism and returns the best completed candidate on cancellation. Ordinary
explicit highlighting is synchronous. Cancellation cannot guarantee a hard
interrupt of an ICU regex already executing, and the package does not enforce
an input-size or execution-time limit. Apply limits at the application boundary
when handling untrusted or very large inputs.
