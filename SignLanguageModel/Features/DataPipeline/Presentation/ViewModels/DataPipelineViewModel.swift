import Foundation

@MainActor
final class DataPipelineViewModel: ObservableObject {
    @Published var jobs: [ProcessingJob] = []
    
    func startProcessing() async {
        // Start processing
    }
}
