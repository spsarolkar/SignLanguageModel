import Foundation
import Combine

struct DashboardKPI: Identifiable {
    let id = UUID()
    let title: String
    let value: Double
    let unit: String
    let trend: Trend
    
    enum Trend {
        case up, down, stable
    }
}
