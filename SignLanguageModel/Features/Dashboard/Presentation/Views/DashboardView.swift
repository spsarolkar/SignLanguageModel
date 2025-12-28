import SwiftUI
import Combine

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                KPIChartsView()
                BodyAnimationView()
            }
            .padding()
        }
        .navigationTitle("Dashboard")
    }
}
