import Foundation

actor ThreadSafeQueue<T: Sendable> {
    private var elements: [T] = []
    
    func enqueue(_ element: T) {
        elements.append(element)
    }
    
    func dequeue() -> T? {
        guard !elements.isEmpty else { return nil }
        return elements.removeFirst()
    }
    
    func isEmpty() -> Bool {
        elements.isEmpty
    }
}
