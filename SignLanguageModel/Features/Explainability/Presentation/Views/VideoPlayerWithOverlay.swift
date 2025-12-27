import SwiftUI
import AVKit

struct VideoPlayerWithOverlay: View {
    @State private var player = AVPlayer()
    
    var body: some View {
        VideoPlayer(player: player)
            .frame(height: 400)
            .overlay(
                SkeletonOverlayView()
            )
    }
}
