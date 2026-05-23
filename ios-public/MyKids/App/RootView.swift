import SwiftUI

struct RootView: View {
    @Environment(AppSession.self) private var session

    var body: some View {
        switch session.mode {
        case .welcome:  WelcomeView()
        case .guest:    mainTabView
        case .loggedIn: mainTabView
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
