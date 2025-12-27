import SwiftUI

struct BodyAnimationView: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(height: 400)
            .overlay(Text("3D Skeleton Animation"))
    }
}
