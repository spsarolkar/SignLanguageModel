import Foundation

final class VideoRepositoryImpl {
    private let dataSource: VideoFileDataSource
    
    init(dataSource: VideoFileDataSource) {
        self.dataSource = dataSource
    }
}
