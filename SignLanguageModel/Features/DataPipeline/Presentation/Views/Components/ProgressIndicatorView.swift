import SwiftUI

struct ProgressIndicatorView: View {
    let progress: Double
    
    var body: some View {
        ProgressView(value: progress)
    }
}
