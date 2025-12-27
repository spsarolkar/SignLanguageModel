import Foundation

struct ComputeAttentionUseCase {
    func execute(modelOutput: [[Double]]) async throws -> AttentionMap {
        AttentionMap(
            weights: [[0.5]],
            dimensions: (1, 1),
            frameIndex: 0
        )
    }
}
