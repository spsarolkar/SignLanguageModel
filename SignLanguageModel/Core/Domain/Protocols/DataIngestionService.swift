import Foundation
import CoreVideo

protocol DataIngestionService: Sendable {
    func extractFrames(
        from asset: VideoAsset,
        samplingRate: Double,
        progressHandler: @escaping @Sendable (Double) -> Void
    ) -> AsyncThrowingStream<FrameData, Error>
    
    func processFrames(
        _ frames: [FrameData],
        using inferenceEngine: any InferenceEngine
    ) async throws -> [SkeletonKeypoint]
    
    func validateVideoFormat(_ asset: VideoAsset) -> Result<Void, ValidationError>
}

enum ValidationError: Error {
    case unsupportedFormat
    case corruptedFile
}
