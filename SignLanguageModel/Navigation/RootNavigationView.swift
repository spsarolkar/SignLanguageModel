import SwiftUI

struct RootNavigationView: View {
    @State private var selectedModule: NavigationItem? = .dashboard
    
    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selectedModule)
        } content: {
            if let module = selectedModule {
                moduleContentView(for: module)
            }
        } detail: {
            Text("Select an item to view details")
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private func moduleContentView(for item: NavigationItem) -> some View {
        switch item {
        case .dashboard:
            DashboardView()
        case .dataPipeline:
            DataPipelineView()
        case .modelLab:
            ModelLabView()
        case .explainability:
            ExplainabilityView()
        }
    }
}
