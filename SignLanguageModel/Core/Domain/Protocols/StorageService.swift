import Foundation

protocol StorageService: Sendable {
    func saveLocally(_ data: Data, forKey key: String) async throws
    func uploadToR2(
        localURL: URL,
        remotePath: String,
        progressHandler: @escaping @Sendable (Double) -> Void
    ) async throws
    func downloadFromR2(remotePath: String) async throws -> URL
    func clearCache() async throws
}
