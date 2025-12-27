import SwiftUI

struct HeatmapConfiguration {
    var gradientColors: [Color] = [.blue, .green, .yellow, .red]
    var opacity: Double = 0.6
    var blurRadius: Double = 10.0
    var interpolationMode: InterpolationMode = .gaussian
    
    enum InterpolationMode {
        case linear, gaussian, bilinear
    }
}
