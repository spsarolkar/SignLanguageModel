import Foundation

actor FrameExtractionActor {
    private var buffer: CircularBuffer<FrameData>
    private var isProcessing = false
    
    init(bufferSize: Int = 120) {
        self.buffer = CircularBuffer(capacity: bufferSize)
    }
    
    func enqueueFrame(_ frame: FrameData) {
        buffer.write(frame)
    }
    
    func dequeueFrame() -> FrameData? {
        buffer.read()
    }
}
