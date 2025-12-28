import Foundation
import os.log
import Combine

final class Logger {
    static let shared = Logger()
    private let logger = os.Logger(subsystem: "com.isl.workbench", category: "general")
    
    func log(_ message: String, level: OSLogType = .info) {
        logger.log(level: level, "\(message)")
    }
}
