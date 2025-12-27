import Foundation

actor ParquetWriterActor {
    private var pendingWrites: [[String: Any]] = []
    
    func addRecord(_ record: [String: Any]) {
        pendingWrites.append(record)
    }
    
    func flush(to url: URL) async throws {
        // Write to Parquet
        pendingWrites.removeAll()
    }
}
