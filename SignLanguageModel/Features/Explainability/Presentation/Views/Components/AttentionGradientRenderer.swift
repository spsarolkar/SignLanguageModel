import SwiftUI
import MetalKit

struct AttentionGradientRenderer: View {
    let attentionMap: AttentionMap
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.blue, .green, .yellow, .red],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .opacity(0.6)
    }
}
