import CoreGraphics
import CoreMedia

struct SkeletonKeypoint: Sendable {
    let joints: [JointType: Keypoint]
    let confidence: Double
    let timestamp: CMTime
}

struct Keypoint: Sendable {
    let position: CGPoint
    let confidence: Float
    let visibility: Bool
}

enum JointType: String, CaseIterable, Sendable {
    case nose, leftEye, rightEye, leftEar, rightEar
    case leftShoulder, rightShoulder, leftElbow, rightElbow
    case leftWrist, rightWrist, leftHip, rightHip
    case leftKnee, rightKnee, leftAnkle, rightAnkle
}

