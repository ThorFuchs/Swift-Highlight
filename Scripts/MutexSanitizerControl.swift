import Dispatch
import Synchronization
let value = Mutex(0)
DispatchQueue.concurrentPerform(iterations: 10000) { _ in
    value.withLock { $0 += 1 }
}
print(value.withLock { $0 })
