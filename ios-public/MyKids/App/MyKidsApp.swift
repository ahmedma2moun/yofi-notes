import SwiftUI
import SwiftData

@main
struct MyKidsApp: App {
    @State private var session = AppSession()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(session)
                .modelContainer(LocalStore.shared.container)
                .onAppear { session.restoreSession() }
        }
    }
}
