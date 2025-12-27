import Foundation

struct ProcessingJob: Identifiable {
    let id = UUID()
    let videoAsset: VideoAsset
    var status: JobStatus
    var progress: Double
    
    enum JobStatus {
        case pending, processing, completed, failed
    }
}
