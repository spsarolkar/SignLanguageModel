import Foundation

final class MLXInferenceService: InferenceEngine {
    let name = "MLX Transformer"
    let keypointTopology = KeypointTopology(joints: JointType.allCases, connections: [])
    var averageInferenceTime: Double { 15.0 }
    
    func predict(frame: FrameData) async throws -> SkeletonKeypoint {
        SkeletonKeypoint(joints: [:], confidence: 0.95, timestamp: frame.timestamp)
    }
    
    func batchPredict(frames: [FrameData]) async throws -> [SkeletonKeypoint] {
        []
    }
    
    func warmup() async throws {}
    func cleanup() async {}
}
