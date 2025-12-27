import Foundation
import AVFoundation

final class VideoFileDataSource {
    func loadVideo(at url: URL) async throws -> AVAsset {
        AVAsset(url: url)
    }
}
