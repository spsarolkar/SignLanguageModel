import Foundation

struct TrainModelUseCase {
    private let modelTrainer: ModelTrainer
    
    init(modelTrainer: ModelTrainer) {
        self.modelTrainer = modelTrainer
    }
    
    func execute(dataset: URL, config: TrainingConfiguration) async throws {
        try await modelTrainer.train(
            dataset: dataset,
            validationSplit: 0.2,
            checkpointInterval: 10
        )
    }
}
