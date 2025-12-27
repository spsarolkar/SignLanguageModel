import Foundation

struct ExtractFramesUseCase {
    private let dataIngestionService: DataIngestionService
    
    init(dataIngestionService: DataIngestionService) {
        self.dataIngestionService = dataIngestionService
    }
    
    func execute(video: VideoAsset, samplingRate: Double) -> AsyncThrowingStream<FrameData, Error> {
        dataIngestionService.extractFrames(
            from: video,
            samplingRate: samplingRate,
            progressHandler: { progress in
                print("Extraction progress: \(progress * 100)%")
            }
        )
    }
}
