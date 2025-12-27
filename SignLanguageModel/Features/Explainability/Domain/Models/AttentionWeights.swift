import Foundation

struct AttentionWeights: Sendable {
    let weights: [Double]
    let shape: (Int, Int, Int) // (batch, heads, sequence)
    let layer: Int
}
