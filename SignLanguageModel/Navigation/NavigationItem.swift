import Foundation

enum NavigationItem: String, CaseIterable, Identifiable {
    case dashboard
    case dataPipeline
    case modelLab
    case explainability
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .dataPipeline: return "Data Pipeline"
        case .modelLab: return "Model Lab"
        case .explainability: return "Explainability"
        }
    }
    
    var icon: String {
        switch self {
        case .dashboard: return "chart.bar.fill"
        case .dataPipeline: return "arrow.triangle.2.circlepath"
        case .modelLab: return "brain.head.profile"
        case .explainability: return "eye.fill"
        }
    }
}
