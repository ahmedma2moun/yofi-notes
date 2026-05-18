import SwiftUI

@main
struct KidsHealthTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            EventListView()
        }
    }
}
