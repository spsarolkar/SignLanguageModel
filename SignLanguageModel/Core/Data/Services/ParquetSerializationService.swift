import Foundation

final class ParquetSerializationService: StorageService {
    func saveLocally(_ data: Data, forKey key: String) async throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(key)
        try data.write(to: url)
    }
    
    func uploadToR2(
        localURL: URL,
        remotePath: String,
        progressHandler: @escaping @Sendable (Double) -> Void
    ) async throws {
        print("Uploading \(localURL) to \(remotePath)")
    }
    
    func downloadFromR2(remotePath: String) async throws -> URL {
        FileManager.default.temporaryDirectory
    }
    
    func clearCache() async throws {
        print("Cache cleared")
    }
}
