import SwiftUI
import Combine

struct VideoThumbnailCell: View {
    let video: VideoAsset
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray)
                .frame(height: 100)
            Text(video.fileName)
                .font(.caption)
        }
    }
}
