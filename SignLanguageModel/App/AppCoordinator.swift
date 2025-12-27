import Foundation
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var selectedModule: NavigationItem = .dashboard
    
    // Dependency injection container
    lazy var dataIngestionService: DataIngestionService = VisionFrameworkService()
    lazy var storageService: StorageService = ParquetSerializationService()
}
