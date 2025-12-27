import Foundation

struct SignSequence: Identifiable, Sendable {
    let id: UUID
    let frames: [SkeletonKeypoint]
    let label: String
    let duration: TimeInterval
}
