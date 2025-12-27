import Vision

actor VisionProcessingActor {
    private var currentJob: UUID?
    
    func processFrame(_ frame: FrameData) async throws -> SkeletonKeypoint {
        // Vision processing
        SkeletonKeypoint(joints: [:], confidence: 0.9, timestamp: frame.timestamp)
    }
}
