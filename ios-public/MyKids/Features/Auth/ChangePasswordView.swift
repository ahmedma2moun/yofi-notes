import SwiftUI

struct ChangePasswordView: View {
    @Environment(AppSession.self) private var session
    @Environment(\.dismiss) private var dismiss

    @State private var currentPassword  = ""
    @State private var newPassword      = ""
    @State private var confirmPassword  = ""
    @State private var isLoading        = false
    @State private var submitAttempted  = false
    @State private var errorMessage: String?
    @State private var succeeded        = false

    var body: some View {
        Form {
            Section("Current Password") {
                SecureField("Enter current password", text: $currentPassword)
                    .textContentType(.password)
            }

            Section("New Password") {
                SecureField("New password (min 6 chars)", text: $newPassword)
                    .textContentType(.newPassword)
                SecureField("Confirm new password", text: $confirmPassword)
                    .textContentType(.newPassword)
            }

            let errors: [String] = (submitAttempted ? validationErrors : [])
                + (errorMessage.map { [$0] } ?? [])

            if !errors.isEmpty {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(errors, id: \.self) { msg in
                            Label(msg, systemImage: "exclamationmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            if succeeded {
                Section {
                    Label("Password changed successfully.", systemImage: "checkmark.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.green)
                        .padding(.vertical, 4)
                }
            }

            Section {
                Button(action: submit) {
                    if isLoading {
                        ProgressView().frame(maxWidth: .infinity)
                    } else {
                        Text("Change Password")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                    }
                }
                .disabled(isLoading || succeeded)
            }
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var validationErrors: [String] {
        var errors: [String] = []
        if currentPassword.isEmpty { errors.append("Enter your current password.") }
        if newPassword.count < 6   { errors.append("New password must be at least 6 characters.") }
        if !confirmPassword.isEmpty && newPassword != confirmPassword {
            errors.append("Passwords do not match.")
        }
        if !newPassword.isEmpty && newPassword == currentPassword {
            errors.append("New password must be different from the current one.")
        }
        return errors
    }

    private func friendlyMessage(for error: Error) -> String {
        if let apiError = error as? APIError, case .httpError(401, _) = apiError {
            return "Current password is incorrect."
        }
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return "No internet connection. Please try again."
            case .timedOut:
                return "The request timed out. Please try again."
            default:
                return "Could not reach the server. Please try again."
            }
        }
        return error.localizedDescription
    }

    private func submit() {
        submitAttempted = true
        guard validationErrors.isEmpty else { return }
        guard let token = session.token else { return }
        isLoading = true
        errorMessage = nil
        Task {
            do {
                try await AuthAPIService.shared.changePassword(
                    currentPassword: currentPassword,
                    newPassword: newPassword,
                    token: token
                )
                succeeded = true
                try? await Task.sleep(for: .seconds(1.5))
                dismiss()
            } catch {
                errorMessage = friendlyMessage(for: error)
            }
            isLoading = false
        }
    }
}
