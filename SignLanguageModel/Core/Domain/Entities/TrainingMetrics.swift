import Foundation

struct TrainingMetrics: Sendable {
    let epoch: Int
    let trainingLoss: Double
    let validationLoss: Double
    let accuracy: Double
    let learningRate: Double
    let gpuUtilization: Double
    let timestamp: Date
}

struct EvaluationMetrics: Sendable {
    let accuracy: Double
    let precision: Double
    let recall: Double
    let f1Score: Double
    let confusionMatrix: [[Int]]
}
