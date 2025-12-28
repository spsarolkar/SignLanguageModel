import Foundation
import Combine

@MainActor
final class DataPipelineViewModel: ObservableObject {
    @Published var jobs: [ProcessingJob] = []
    
    func startProcessing() async {
        // Start processing
    }
}
