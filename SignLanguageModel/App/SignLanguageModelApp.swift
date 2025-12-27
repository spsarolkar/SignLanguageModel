import SwiftUI

@main
struct ISLScientificWorkbenchApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            RootNavigationView()
                .environmentObject(coordinator)
        }
    }
}
