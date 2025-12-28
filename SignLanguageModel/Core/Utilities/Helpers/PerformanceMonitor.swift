import Foundation
import Combine

final class PerformanceMonitor {
    static let shared = PerformanceMonitor()
    
    func startMeasuring(label: String) -> UUID {
        UUID()
    }
    
    func stopMeasuring(id: UUID) {
        print("Measurement complete")
    }
}
