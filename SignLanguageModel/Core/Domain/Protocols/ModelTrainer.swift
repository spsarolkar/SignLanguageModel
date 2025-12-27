import Foundation

protocol ModelTrainer: Sendable {
    var configuration: TrainingConfiguration { get }
    var metricsStream: AsyncStream<TrainingMetrics> { get }
    
    func initializeModel(architecture: ModelArchitecture) async throws
    func train(
        dataset: URL,
        validationSplit: Double,
        checkpointInterval: Int
    ) async throws
    func pauseTraining() async throws
    func resumeTraining() async throws
    func evaluate(testData: URL) async throws -> EvaluationMetrics
    func exportToCoreML(destination: URL) async throws
}

struct TrainingConfiguration: Sendable {
    let batchSize: Int
    let learningRate: Double
    let epochs: Int
}

enum ModelArchitecture: String, Sendable {
    case transformer
    case lstm
}
