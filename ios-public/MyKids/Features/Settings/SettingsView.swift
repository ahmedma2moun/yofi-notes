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
                        NavigationLink("Change Password") {
                            ChangePasswordView()
                        }
                    }

                    Section {
                        Button(role: .destructive) {
                            showSignOut = true
                        } label: {
                            Label("Sign Out", systemImage: "arrow.right.square")
                        }
                        .accessibilityLabel("Sign out")
                    }
                } else {
                    Section("Mode") {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.mkPrimaryLight)
                                    .frame(width: 44, height: 44)
                                Image(systemName: "person")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(Color.mkPrimary)
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                Text("Guest Mode")
                                    .font(.headline)
                                Text("Your data is stored on this device only. Sign in to sync and share with co-parents.")
                                    .font(.caption)
                                    .foregroundStyle(Color.mkTextSecondary)
                            }
                        }
                        .padding(.vertical, 4)
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
                Text("You will need to sign in again. Local data stays on the device.")
            }
        }
    }
}

private extension Bundle {
    var appVersion: String {
        (infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0"
    }
}
