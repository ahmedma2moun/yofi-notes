import SwiftUI

struct RegisterView: View {
    @Environment(AppSession.self) private var session
    @Environment(\.dismiss) private var dismiss

    @State private var name            = ""
    @State private var email           = ""
    @State private var password        = ""
    @State private var confirmPassword = ""
    @State private var isLoading       = false
    @State private var submitAttempted = false
    @State private var serverError: String?

    // Guest data sync
    @State private var localChildCount  = 0
    @State private var shouldSyncGuest  = true

    private var hasGuestData: Bool { session.mode == .guest && localChildCount > 0 }

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

                if hasGuestData {
                    Section {
                        Toggle(isOn: $shouldSyncGuest) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Import my local data")
                                Text(
                                    "\(localChildCount) \(localChildCount == 1 ? "child" : "children") and their events will be uploaded to your new account."
                                )
                                .font(.caption)
                                .foregroundStyle(Color.mkTextSecondary)
                            }
                        }
                        .tint(Color.mkPrimary)
                    }
                }

                Section {
                    if submitAttempted {
                        ForEach(validationErrors, id: \.self) { msg in
                            Text(msg)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                    if let serverError {
                        Text(serverError)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }

                    Button(action: register) {
                        if isLoading {
                            ProgressView().frame(maxWidth: .infinity)
                        } else {
                            Text("Create Account")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(isLoading || (submitAttempted && !validationErrors.isEmpty))
                }
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .task {
                guard session.mode == .guest else { return }
                localChildCount = (try? LocalStore.shared.fetchChildren().count) ?? 0
            }
        }
    }

    private var validationErrors: [String] {
        var errors: [String] = []
        if email.isEmpty || !email.contains("@") { errors.append("Enter a valid email address.") }
        if password.count < 6 { errors.append("Password must be at least 6 characters.") }
        if !confirmPassword.isEmpty && password != confirmPassword { errors.append("Passwords do not match.") }
        return errors
    }

    private func register() {
        submitAttempted = true
        guard validationErrors.isEmpty else { return }
        isLoading = true
        serverError = nil
        Task {
            do {
                let (token, user) = try await AuthAPIService.shared.register(
                    email: email,
                    password: password,
                    name: name.isEmpty ? nil : name
                )
                if hasGuestData && shouldSyncGuest {
                    await GuestDataSyncer.sync(token: token)
                }
                session.signIn(token: token, user: user)
                dismiss()
            } catch {
                serverError = error.localizedDescription
            }
            isLoading = false
        }
    }
}
