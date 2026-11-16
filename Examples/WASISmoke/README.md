# WASI smoke test

This standalone consumer checks Swift syntax tokens and escaped HTML under
WASI Preview 1. It depends on the package via `../..`; it is not a package
product and does not require JavaScript at library runtime.

Use an official Swift.org toolchain that exactly matches the installed WASI
SDK. On macOS the Xcode toolchain can have the same marketing version but an
incompatible compiler build. If Swiftly and its 6.4.2 toolchain are installed:

```sh
cd Examples/WASISmoke
swiftly run swift build +6.4.2 --swift-sdk swift-6.4.2-RELEASE_wasm --product WASISmoke
```

Locate `WASISmoke.wasm` in the build products and run it with a WASI Preview 1
runtime. For example, with Node.js 24 (whose WASI API is experimental):

```sh
node --experimental-wasi-unstable-preview1 run-wasi.mjs /path/to/WASISmoke.wasm
```

A successful run prints `WASI highlight and HTML smoke passed`. This single
case checks one Swift grammar and the HTML renderer; it is not a WASI run of
the full language or fixture suite.
