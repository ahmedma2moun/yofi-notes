import SwiftUI

struct SettingsView: View {
    @Environment(AppSession.self) private var session
    @State private var showSignOut = false

    var body: some View {
        NavigationStack {
            List {
                if session.isLoggedIn, let user = session.currentUser {
                    Section("Account") {
                        LabeledContent("Name", value: user.name ?? "—")
                        LabeledContent("Email", value: user.email)
                    }

                    Section {
                        Button(role: .destructive) {
                            showSignOut = true
                        } label: {
                            Label("Sign Out", systemImage: "arrow.right.square")
                        }
                    }
                } else {
                    Section("Mode") {
                        Label("Guest Mode", systemImage: "person.slash")
                            .foregroundStyle(.secondary)
                        Text("Your data is stored on this device only. Create an account to sync and share.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Section {
                        NavigationLink("Sign In") { LoginView() }
                        NavigationLink("Create Account") { RegisterView() }
                    }
                }

                Section("About") {
                    LabeledContent("Version", value: Bundle.main.appVersion)
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog("Sign Out?", isPresented: $showSignOut) {
                Button("Sign Out", role: .destructive) { session.signOut() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("You will need to sign in again to access synced data.")
            }
        }
    }
}

private extension Bundle {
    var appVersion: String {
        (infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
    }
}
