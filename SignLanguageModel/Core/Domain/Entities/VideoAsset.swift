import Foundation
import AVFoundation

struct VideoAsset: Identifiable, Sendable {
    let id: UUID
    let url: URL
    let fileName: String
    let duration: TimeInterval
    let frameRate: Double
    let resolution: CGSize
    let creationDate: Date
}
