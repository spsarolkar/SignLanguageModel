import Foundation
import AVFoundation
import Combine

@MainActor
final class ExplainabilityViewModel: ObservableObject {
    @Published var currentFrame: Int = 0
    @Published var attentionMap: AttentionMap?
    @Published var isPlaying = false
    
    func loadVideo(url: URL) async {
        // Load video logic
    }
    
    func updateAttentionMap(for frame: Int) async {
        // Update attention map
    }
}
