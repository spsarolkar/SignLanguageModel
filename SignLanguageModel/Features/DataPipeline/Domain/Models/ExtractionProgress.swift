import Foundation

struct ExtractionProgress {
    let jobID: UUID
    let currentFrame: Int
    let totalFrames: Int
    var percentage: Double {
        Double(currentFrame) / Double(totalFrames)
    }
}
