import AVFoundation
import CoreGraphics

protocol VideoProcessingService: Sendable {
    func importVideo(from url: URL) async throws -> VideoAsset
    func extractMetadata(from asset: VideoAsset) async throws -> VideoMetadata
    func generateThumbnail(
        for asset: VideoAsset,
        at time: CMTime?
    ) async throws -> CGImage
    func trimVideo(
        asset: VideoAsset,
        startTime: CMTime,
        endTime: CMTime
    ) async throws -> VideoAsset
}

struct VideoMetadata: Sendable {
    let duration: TimeInterval
    let fps: Double
    let resolution: CGSize
    let codec: String
}
