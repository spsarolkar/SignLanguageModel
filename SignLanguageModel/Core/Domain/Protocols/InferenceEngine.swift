import Foundation

protocol InferenceEngine: Sendable {
    var name: String { get }
    var keypointTopology: KeypointTopology { get }
    var averageInferenceTime: Double { get async }
    
    func predict(frame: FrameData) async throws -> SkeletonKeypoint
    func batchPredict(frames: [FrameData]) async throws -> [SkeletonKeypoint]
    func warmup() async throws
    func cleanup() async
}

struct KeypointTopology: Sendable {
    let joints: [JointType]
    let connections: [(JointType, JointType)]
}
