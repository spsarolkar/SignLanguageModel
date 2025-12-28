import Metal
import Combine

final class MetalHelpers {
    static func createDevice() -> MTLDevice? {
        MTLCreateSystemDefaultDevice()
    }
}
