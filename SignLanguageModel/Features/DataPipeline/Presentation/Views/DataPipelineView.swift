import SwiftUI
import Combine

struct DataPipelineView: View {
    @StateObject private var viewModel = DataPipelineViewModel()
    
    var body: some View {
        VStack {
            VideoGridView()
            ProcessingQueueView()
        }
        .navigationTitle("Data Pipeline")
    }
}
