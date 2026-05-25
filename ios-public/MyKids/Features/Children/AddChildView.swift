import SwiftUI

struct AddChildView: View {
    @ObservedObject var viewModel: ChildrenViewModel
    @Environment(\.dismiss) private var dismiss

    let editingChild: Child?

    @State private var name: String
    @State private var hasBirthDate: Bool
    @State private var birthDate: Date
    @State private var isSaving = false

    init(viewModel: ChildrenViewModel, editingChild: Child? = nil) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.editingChild = editingChild
        _name        = State(initialValue: editingChild?.name ?? "")
        _hasBirthDate = State(initialValue: editingChild?.birthDate != nil)
        _birthDate   = State(initialValue: editingChild?.birthDate ?? Date())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Child's Name") {
                    TextField("Name", text: $name)
                }

                Section {
                    Toggle("Add Birth Date", isOn: $hasBirthDate.animation(.easeInOut(duration: 0.2)))

                    if hasBirthDate {
                        DatePicker(
                            "Birth Date",
                            selection: $birthDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
            }
            .navigationTitle(editingChild == nil ? "Add Child" : "Edit Child")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        save()
                    } label: {
                        Text("Save").fontWeight(.bold)
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || isSaving)
                }
            }
            .overlay { if isSaving { ProgressView() } }
        }
    }

    private func save() {
        isSaving = true
        let bd = hasBirthDate ? birthDate : nil
        Task {
            if let child = editingChild {
                await viewModel.updateChild(child, name: name.trimmingCharacters(in: .whitespaces), birthDate: bd)
            } else {
                await viewModel.addChild(name: name.trimmingCharacters(in: .whitespaces), birthDate: bd)
            }
            isSaving = false
            dismiss()
        }
    }
}
