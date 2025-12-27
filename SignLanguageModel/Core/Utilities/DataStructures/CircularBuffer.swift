import Foundation

final class CircularBuffer<T: Sendable>: @unchecked Sendable {
    private var buffer: [T?]
    private var readIndex = 0
    private var writeIndex = 0
    private let capacity: Int
    private let lock = NSLock()
    
    init(capacity: Int) {
        self.capacity = capacity
        self.buffer = Array(repeating: nil, count: capacity)
    }
    
    func write(_ element: T) {
        lock.lock()
        defer { lock.unlock() }
        buffer[writeIndex] = element
        writeIndex = (writeIndex + 1) % capacity
    }
    
    func read() -> T? {
        lock.lock()
        defer { lock.unlock() }
        guard readIndex != writeIndex else { return nil }
        let element = buffer[readIndex]
        readIndex = (readIndex + 1) % capacity
        return element
    }
}
