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
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Share \(child.name)'s profile with another parent or caregiver. They'll be able to view and add health events.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Invite Code") {
                    if let code = inviteCode {
                        VStack(spacing: 12) {
                            Text(code)
                                .font(.system(.title, design: .monospaced).bold())
                                .tracking(4)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            if let expiry = inviteExpiry {
                                Text("Expires \(expiry.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Button {
                                UIPasteboard.general.string = code
                                withAnimation { copied = true }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation { copied = false }
                                }
                            } label: {
                                Label(copied ? "Copied!" : "Copy Code", systemImage: copied ? "checkmark" : "doc.on.doc")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)

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
                    } else {
                        Button(action: generateInvite) {
                            if isGenerating {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            } else {
                                Label("Generate Invite Code", systemImage: "link.badge.plus")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .disabled(isGenerating)
                    }
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.subheadline)
                    }
                }

                Section {
                    Text("Each invite code is single-use and expires in 7 days. Shared users can add events but cannot delete the child or manage sharing.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Share Child")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
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

