# Linux registry lock comparison

On 17 November 2026, two separate GitHub-hosted Ubuntu 24.04 x86_64 runners
compared the same baseline (`194c372c92eabfde9222c860ceced7f1f66ccb09`) to
Linux lock candidates using the pinned Swift 6.4 container. Each runner built
both binaries with `swift build -c release -j 4` and ran
`Benchmarks/paired_registry_ab.py` with 15 interleaved pairs per scenario.
The JSON files retain the toolchain, host, executable hashes, individual
samples, checksums, and confidence intervals. Runner variability means the two
candidate campaigns are not a direct paired comparison with each other.

| Scenario | NSLock vs baseline | pthread vs baseline |
| --- | ---: | ---: |
| warm highlight | -0.1% (-0.8% to +0.5%) | +1.2% (+0.2% to +2.2%) |
| warm auto-detection | +0.1% (-0.4% to +0.6%) | +0.4% (-0.7% to +1.6%) |
| cold contention | 0.0% (-3.7% to +3.8%) | +2.3% (-0.6% to +5.3%) |
| warm contention, 1 task | +1.0% (+0.3% to +1.8%) | +0.6% (-0.4% to +1.6%) |
| warm contention, 8 tasks | +7.7% (+4.8% to +10.6%) | +11.9% (+10.3% to +13.6%) |
| warm contention, 32 tasks | +5.9% (+4.4% to +7.5%) | +12.4% (+11.1% to +13.8%) |

Values are paired geometric mean latency changes with 95% intervals; positive
values are slower. NSLock's warm-contention medians were 1552.5 vs 1645.8 ns/op
at eight tasks and 1569.1 vs 1672.6 ns/op at 32 tasks. The pthread candidate
was not retained: it increased unsafe implementation complexity and did not
improve these contention results. The retained NSLock trade-off prioritizes
observable Linux concurrency checks, with a measured contention cost; it is
not a claim that earlier Mutex warnings were all genuine races.

Raw logs: [NSLock run](https://github.com/ThorFuchs/Swift-Highlight/actions/runs/44085538347),
[pthread run](https://github.com/ThorFuchs/Swift-Highlight/actions/runs/44086922636).
