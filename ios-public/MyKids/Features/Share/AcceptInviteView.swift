import SwiftUI

struct AcceptInviteView: View {
    let session: AppSession
    let onAccepted: (Child) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var code = ""
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Enter the invite code another parent shared with you to get access to their child's health tracker.")
                        .font(.subheadline)
                        .foregroundStyle(Color.mkTextSecondary)
                        .padding(.vertical, 4)
                }

                Section("Invite Code") {
                    TextField("e.g. AB3D5FGH", text: $code)
                        .font(.system(.body, design: .monospaced))
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .onChange(of: code) { _, new in
                            code = new.uppercased().replacingOccurrences(of: " ", with: "")
                        }
                }

                Section {
                    if let errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }

                    Button(action: accept) {
                        if isLoading {
                            ProgressView().frame(maxWidth: .infinity)
                        } else {
                            Text("Join")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(code.count < 6 || isLoading)
                }
            }
            .navigationTitle("Accept Invite")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func accept() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                guard let token = session.token else { return }
                let child = try await ChildrenAPIService.shared.acceptInvite(
                    code: code,
                    token: token
                )
                onAccepted(child)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
