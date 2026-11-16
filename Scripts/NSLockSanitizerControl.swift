import Foundation
import Dispatch
final class Counter: @unchecked Sendable {
    private let lock = NSLock()
    private var value = 0
    func increment() { lock.lock(); defer { lock.unlock() }; value += 1 }
    func read() -> Int { lock.lock(); defer { lock.unlock() }; return value }
}
let counter = Counter()
DispatchQueue.concurrentPerform(iterations: 10_000) { _ in counter.increment() }
print(counter.read())
