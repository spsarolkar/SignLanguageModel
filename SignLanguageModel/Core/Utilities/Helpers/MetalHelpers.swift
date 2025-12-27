import Metal

final class MetalHelpers {
    static func createDevice() -> MTLDevice? {
        MTLCreateSystemDefaultDevice()
    }
}
