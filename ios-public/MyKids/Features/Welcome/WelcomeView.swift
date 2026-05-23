import SwiftUI

struct WelcomeView: View {
    @Environment(AppSession.self) private var session
    @State private var showLogin    = false
    @State private var showRegister = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: "figure.2.and.child.holdinghands")
                        .font(.system(size: 80))
                        .foregroundStyle(.blue)
                        .symbolRenderingMode(.hierarchical)

                    Text("MyKids")
                        .font(.largeTitle.bold())

                    Text("Track your children's health events")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 60)

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        showLogin = true
                    } label: {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .font(.headline)
                    }

                    Button {
                        showRegister = true
                    } label: {
                        Text("Create Account")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .foregroundStyle(.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .font(.headline)
                    }

                    Button {
                        session.continueAsGuest()
                    } label: {
                        Text("Continue as Guest")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    }

                    Text("Guest mode saves data on this device only.\nSign in to sync across devices and share with co-parents.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .sheet(isPresented: $showLogin) {
                LoginView()
            }
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }
}
