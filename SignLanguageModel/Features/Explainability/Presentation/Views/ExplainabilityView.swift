import SwiftUI

struct ExplainabilityView: View {
    @StateObject private var viewModel = ExplainabilityViewModel()
    
    var body: some View {
        VStack {
            VideoPlayerWithOverlay()
            HeatmapCanvasView()
        }
        .navigationTitle("Explainability")
    }
}
