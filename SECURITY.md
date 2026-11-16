# Security policy

## Supported versions

There is currently no public release. Once a release exists, security fixes are
intended for the latest minor version of the current major version. No backport
or response-time guarantee is made.

## Report a vulnerability

Do not post a suspected vulnerability, sensitive input or exploit publicly.
When private vulnerability reporting is enabled for the repository, use its
Security tab or [create a private advisory](https://github.com/ThorFuchs/Swift-Highlight/security/advisories/new).
The maintainer must verify that this route is enabled and reachable before the
repository is made public. If it is unavailable, contact the maintainer through
a private GitHub channel without publishing sensitive details.

Include the package version or commit, platform and Swift toolchain, the API and
language used, a minimal non-sensitive reproducer, and expected and observed
behavior. A problem that also reproduces in the pinned upstream project may
also need an upstream report under its security policy.

## Scope and limits

HTML source text and class values are escaped or validated by the HTML renderer,
but the package does not sanitize surrounding HTML. The engine uses regular
expressions and enforces no hard time or input-size limit; synchronous regex
execution cannot be forcibly interrupted by task cancellation. Callers handling
untrusted inputs need their own resource controls. Crashes, incorrect range
validation, escaping failures and unexpected unbounded behavior should be
investigated. See [API contracts](Documentation/API-CONTRACTS.md).
