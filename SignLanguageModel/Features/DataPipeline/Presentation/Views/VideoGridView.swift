import SwiftUI

struct VideoGridView: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                // Video thumbnails
            }
        }
    }
}
