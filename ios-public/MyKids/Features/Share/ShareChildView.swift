import SwiftUI

struct ShareChildView: View {
    let child: Child
    let session: AppSession
    @Environment(\.dismiss) private var dismiss

    @State private var inviteResult: InviteResponse?
    private var inviteCode: String? { inviteResult?.code }
    private var inviteExpiry: Date? { inviteResult?.expiresAt }
    @State private var isGenerating = false
    @State private var errorMessage: String?
    @State private var copied = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Share \(child.name)'s profile with another parent or caregiver. They'll be able to view and add health events.")
                        .font(.subheadline)
                        .foregroundStyle(Color.mkTextSecondary)
                        .padding(.vertical, 4)
                }

                if let code = inviteCode {
                    Section {
                        VStack(spacing: 16) {
                            VStack(spacing: 6) {
                                Text(formatted(code: code))
                                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                                    .tracking(4)
                                    .frame(maxWidth: .infinity)

                                if let expiry = inviteExpiry {
                                    Text("Expires \(expiry.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption)
                                        .foregroundStyle(Color.mkTextSecondary)
                                }
                            }
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity)
                            .background(Color.mkSurfaceSecondary)
                            .clipShape(RoundedRectangle(cornerRadius: 16))

                            Button {
                                UIPasteboard.general.string = code
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                                    copied = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation { copied = false }
                                }
                            } label: {
                                Label(
                                    copied ? "Copied!" : "Copy Code",
                                    systemImage: copied ? "checkmark" : "doc.on.doc"
                                )
                                .frame(maxWidth: .infinity)
                                .scaleEffect(copied ? 1.05 : 1.0)
                            }
                            .foregroundStyle(copied ? Color.mkSuccess : Color.mkPrimary)
                            .padding(.vertical, 12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(copied ? Color.mkSuccess : Color.mkPrimary, lineWidth: 1.5)
                            )
                            .accessibilityLabel(copied ? "Copied" : "Copy code")

                            ShareLink(
                                item: "Join \(child.name)'s health tracker! Use invite code: \(code)",
                                subject: Text("MyKids Invite"),
                                message: Text("I'd like you to track \(child.name)'s health events with me. Open MyKids and enter invite code: \(code)")
                            ) {
                                Label("Share via…", systemImage: "square.and.arrow.up")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.vertical, 4)
                    }
                } else {
                    Section {
                        Button(action: generateInvite) {
                            if isGenerating {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            } else {
                                Label("Generate Invite Code", systemImage: "link.badge.plus")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isGenerating)
                    }

                    Section {
                        Text("Each code is single-use and expires in 7 days.")
                            .font(.caption)
                            .foregroundStyle(Color.mkTextSecondary)
                    }
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Share \(child.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.bold)
                }
            }
        }
    }

    private func formatted(code: String) -> String {
        let clean = code.replacingOccurrences(of: " ", with: "")
        guard clean.count >= 4 else { return clean }
        let mid = clean.index(clean.startIndex, offsetBy: min(4, clean.count))
        return String(clean[..<mid]) + " " + String(clean[mid...])
    }

    private func generateInvite() {
        isGenerating = true
        errorMessage = nil
        Task {
            do {
                guard let token = session.token else { return }
                inviteResult = try await ChildrenAPIService.shared.generateInvite(
                    childId: child.id, token: token
                )
            } catch {
                errorMessage = error.localizedDescription
            }
            isGenerating = false
        }
    }
}
