import Foundation

struct FeatureFlags {
    static let enableMLXTraining = true
    static let enableCloudflareR2 = true
    static let debugLogging = Environment.current == .development
}
