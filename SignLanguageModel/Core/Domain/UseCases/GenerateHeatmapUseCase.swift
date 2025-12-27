import Foundation
import MetalKit

struct GenerateHeatmapUseCase {
    private let heatmapRenderer: HeatmapRenderer
    
    init(heatmapRenderer: HeatmapRenderer) {
        self.heatmapRenderer = heatmapRenderer
    }
    
    func execute(
        attentionMap: AttentionMap,
        skeleton: SkeletonKeypoint,
        frameSize: CGSize
    ) async throws -> MTLTexture {
        try await heatmapRenderer.renderHeatmap(
            attentionMap: attentionMap,
            skeleton: skeleton,
            frameSize: frameSize
        )
    }
}
