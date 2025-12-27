import CoreVideo
import AVFoundation

struct FrameData: Sendable {
    let timestamp: CMTime
    let pixelBuffer: CVPixelBuffer
    let index: Int
    let metadata: [String: Any]
}
