import Foundation

struct AttentionMap: Sendable {
    let weights: [[Double]]
    let dimensions: (rows: Int, cols: Int)
    let frameIndex: Int
}
