import Foundation

struct ExportDataUseCase {
    private let storageService: StorageService
    
    init(storageService: StorageService) {
        self.storageService = storageService
    }
    
    func execute(data: Data, remotePath: String) async throws {
        // Save locally first
        try await storageService.saveLocally(data, forKey: remotePath)
        
        // Upload to R2
        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(remotePath)
        try await storageService.uploadToR2(
            localURL: localURL,
            remotePath: remotePath,
            progressHandler: { print("Upload: \($0 * 100)%") }
        )
    }
}
