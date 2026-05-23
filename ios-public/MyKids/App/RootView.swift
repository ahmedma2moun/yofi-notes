import SwiftUI

struct RootView: View {
    @Environment(AppSession.self) private var session

    var body: some View {
        if session.isLoggedIn || session.mode == .guest {
            mainTabView
        } else {
            WelcomeView()
        }
    }

    private var mainTabView: some View {
        TabView {
            ChildrenListView(session: session)
                .tabItem { Label("Children", systemImage: "figure.2.and.child.holdinghands") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}
