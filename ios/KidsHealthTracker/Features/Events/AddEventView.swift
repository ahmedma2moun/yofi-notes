import SwiftUI

struct AddEventView: View {
    @ObservedObject var viewModel: EventViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var selectedType: EventType = .medicine
    private let childName = "Youssef"
    @State private var notes = ""

    // Time
    @State private var useCustomTime = false
    @State private var customTime = Date()

    // Medicine
    @State private var medicineName = ""
    @State private var doseMg = ""
    @State private var unit = "mg"

    // Temperature
    @State private var tempValue = ""
    @State private var tempMethod = "oral"

    // Custom
    @State private var customLabel = ""

    @State private var isSaving = false

    private static let cairo = TimeZone(identifier: "Africa/Cairo")!

    var body: some View {
        NavigationStack {
            Form {
                Section("Event Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(EventType.allCases, id: \.self) { type in
                            Label(type.displayName, systemImage: type.systemImage).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Time (Cairo)") {
                    Picker("When", selection: $useCustomTime) {
                        Text("Now").tag(false)
                        Text("Custom").tag(true)
                    }
                    .pickerStyle(.segmented)

                    if useCustomTime {
                        DatePicker(
                            "Date & Time",
                            selection: $customTime,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .environment(\.timeZone, Self.cairo)
                    }
                }

                payloadSection

                Section("Notes (optional)") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Log Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(isSaving)
                }
            }
            .overlay {
                if isSaving { ProgressView() }
            }
        }
    }

    @ViewBuilder
    private var payloadSection: some View {
        switch selectedType {
        case .medicine:
            Section("Medicine") {
                TextField("Medicine name", text: $medicineName)
                TextField("Dose", text: $doseMg)
                    .keyboardType(.decimalPad)
                Picker("Unit", selection: $unit) {
                    ForEach(["mg", "ml", "tablet", "cm"], id: \.self) { Text($0) }
                }
            }
        case .temperature:
            Section("Temperature") {
                TextField("Value (°C)", text: $tempValue)
                    .keyboardType(.decimalPad)
                Picker("Method", selection: $tempMethod) {
                    ForEach(["oral", "axillary", "rectal", "forehead"], id: \.self) {
                        Text($0.capitalized)
                    }
                }
            }
        case .custom:
            Section("Custom Event") {
                TextField("Event label", text: $customLabel)
            }
        }
    }

    private var occurredAt: Date {
        useCustomTime ? customTime : Date()
    }

    private func save() {
        isSaving = true
        Task {
            await viewModel.logEvent(
                type: selectedType,
                childName: childName,
                notes: notes.isEmpty ? nil : notes,
                payload: buildPayload(),
                occurredAt: occurredAt
            )
            isSaving = false
            dismiss()
        }
    }

    private func buildPayload() -> [String: Any] {
        switch selectedType {
        case .medicine:
            return [
                "medicineName": medicineName,
                "doseMg": Double(doseMg) ?? 0.0,
                "unit": unit,
            ]
        case .temperature:
            return [
                "valueCelsius": Double(tempValue) ?? 0.0,
                "method": tempMethod,
            ]
        case .custom:
            return ["label": customLabel]
        }
    }
}
