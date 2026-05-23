import SwiftUI

struct RegisterView: View {
    @Environment(AppSession.self) private var session
    @Environment(\.dismiss) private var dismiss

    @State private var name     = ""
    @State private var email    = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Your Name") {
                    TextField("Full name (optional)", text: $name)
                        .textContentType(.name)
                }

                Section("Account") {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    SecureField("Password (min 6 chars)", text: $password)
                        .textContentType(.newPassword)

                    SecureField("Confirm Password", text: $confirmPassword)
                        .textContentType(.newPassword)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.subheadline)
                    }
                }

                Section {
                    Button(action: register) {
                        if isLoading {
                            ProgressView().frame(maxWidth: .infinity)
                        } else {
                            Text("Create Account")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(isLoading || !isFormValid)
                }
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private var isFormValid: Bool {
        !email.isEmpty && password.count >= 6 && password == confirmPassword
    }

    private func register() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let (token, user) = try await AuthAPIService.shared.register(
                    email: email,
                    password: password,
                    name: name.isEmpty ? nil : name
                )
                session.signIn(token: token, user: user)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
