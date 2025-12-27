import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var kpis: [DashboardKPI] = []
    
    func loadData() async {
        // Load dashboard data
    }
}
