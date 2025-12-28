import Foundation
import Combine

@MainActor
final class ModelLabViewModel: ObservableObject {
    @Published var isTraining = false
    @Published var currentEpoch = 0
    @Published var trainingLoss: Double = 0.0
    @Published var validationAccuracy: Double = 0.0

    func startTraining() async {
        // Training logic
    }

    func stopTraining() {
        // Stop training logic
    }

    func loadModel(url: URL) async {
        // Load model logic
    }
}