import SwiftUI
import MetalKit

protocol HeatmapRenderer: Sendable {
    var gradientColors: [Color] { get set }
    var opacity: Double { get set }
    
    func renderHeatmap(
        attentionMap: AttentionMap,
        skeleton: SkeletonKeypoint,
        frameSize: CGSize
    ) async throws -> MTLTexture
    
    func renderSequence(
        attentionMaps: [AttentionMap],
        skeletons: [SkeletonKeypoint],
        frameSize: CGSize
    ) -> AsyncThrowingStream<MTLTexture, Error>
    
    func colorForWeight(_ weight: Double) -> Color
}
