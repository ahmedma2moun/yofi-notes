import SwiftUI

struct WelcomeView: View {
    @Environment(AppSession.self) private var session
    @State private var showLogin    = false
    @State private var showRegister = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.mkPrimaryLight)
                        .frame(width: 132, height: 132)
                    Image(systemName: "figure.2.and.child.holdinghands")
                        .font(.system(size: 80))
                        .foregroundStyle(Color.mkPrimary)
                        .symbolRenderingMode(.hierarchical)
                }

                Text("MyKids")
                    .font(.largeTitle.bold())

                Text("Track your children's health events")
                    .font(.subheadline)
                    .foregroundStyle(Color.mkTextSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom, 60)

            Spacer()

            VStack(spacing: 12) {
                Button {
                    showLogin = true
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.mkPrimary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button {
                    showRegister = true
                } label: {
                    Text("Create Account")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.mkSurfaceSecondary)
                        .foregroundStyle(Color.mkTextPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Button {
                    session.continueAsGuest()
                } label: {
                    Text("Continue as Guest")
                        .font(.subheadline)
                        .foregroundStyle(Color.mkPrimary)
                }
                .padding(.top, 4)

                Text("Guest mode saves data on this device only.\nSign in to sync across devices and share with co-parents.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.mkTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
            .padding(.horizontal, 16)
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
