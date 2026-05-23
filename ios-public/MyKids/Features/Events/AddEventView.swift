import SwiftUI

struct AddEventView: View {
    @ObservedObject var viewModel: EventsViewModel
    @Environment(\.dismiss) private var dismiss

    let editingEvent: HealthEvent?

    @State private var selectedType: EventType
    @State private var notes: String
    @State private var useCustomTime: Bool
    @State private var customTime: Date

    // Medicine
    @State private var medicineName: String
    @State private var doseMg: String
    @State private var unit: String

    // Temperature
    @State private var tempValue: String
    @State private var tempMethod: String

    // Custom
    @State private var customLabel: String

    @State private var isSaving = false

    init(viewModel: EventsViewModel, editingEvent: HealthEvent? = nil) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        self.editingEvent = editingEvent

        if let e = editingEvent {
            _selectedType    = State(initialValue: e.type)
            _notes           = State(initialValue: e.notes ?? "")
            _useCustomTime   = State(initialValue: true)
            _customTime      = State(initialValue: e.occurredAt)

            switch e.type {
            case .medicine:
                _medicineName = State(initialValue: (e.payload?["medicineName"]?.value as? String) ?? "")
                let dose = e.payload?["doseMg"]?.value
                let doseStr = (dose as? Double).map { d in
                    d == Double(Int(d)) ? String(Int(d)) : String(d)
                } ?? ""
                _doseMg       = State(initialValue: doseStr)
                _unit         = State(initialValue: (e.payload?["unit"]?.value as? String) ?? "mg")
                _tempValue    = State(initialValue: "")
                _tempMethod   = State(initialValue: "oral")
                _customLabel  = State(initialValue: "")
            case .temperature:
                _medicineName = State(initialValue: "")
                _doseMg       = State(initialValue: "")
                _unit         = State(initialValue: "mg")
                _tempValue    = State(initialValue: (e.payload?["valueCelsius"]?.value as? Double).map { String($0) } ?? "")
                _tempMethod   = State(initialValue: (e.payload?["method"]?.value as? String) ?? "oral")
                _customLabel  = State(initialValue: "")
            case .custom:
                _medicineName = State(initialValue: "")
                _doseMg       = State(initialValue: "")
                _unit         = State(initialValue: "mg")
                _tempValue    = State(initialValue: "")
                _tempMethod   = State(initialValue: "oral")
                _customLabel  = State(initialValue: (e.payload?["label"]?.value as? String) ?? "")
            }
        } else {
            _selectedType  = State(initialValue: .medicine)
            _notes         = State(initialValue: "")
            _useCustomTime = State(initialValue: false)
            _customTime    = State(initialValue: Date())
            _medicineName  = State(initialValue: "")
            _doseMg        = State(initialValue: "")
            _unit          = State(initialValue: "mg")
            _tempValue     = State(initialValue: "")
            _tempMethod    = State(initialValue: "oral")
            _customLabel   = State(initialValue: "")
        }
    }

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

                Section("Time") {
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
                    }
                }

                payloadSection

                Section("Notes (optional)") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(editingEvent == nil ? "Log Event" : "Edit Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save).disabled(isSaving)
                }
            }
            .overlay { if isSaving { ProgressView() } }
        }
    }

    @ViewBuilder
    private var payloadSection: some View {
        switch selectedType {
        case .medicine:
            Section("Medicine") {
                TextField("Medicine name", text: $medicineName)
                TextField("Dose", text: $doseMg).keyboardType(.decimalPad)
                Picker("Unit", selection: $unit) {
                    ForEach(["mg", "ml", "tablet", "cm"], id: \.self) { Text($0) }
                }
            }
        case .temperature:
            Section("Temperature") {
                TextField("Value (°C)", text: $tempValue).keyboardType(.decimalPad)
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

    private var occurredAt: Date { useCustomTime ? customTime : Date() }

    private func save() {
        isSaving = true
        Task {
            if let event = editingEvent {
                await viewModel.updateEvent(
                    id: event.id,
                    type: selectedType,
                    notes: notes.isEmpty ? nil : notes,
                    payload: buildPayload(),
                    occurredAt: occurredAt
                )
            } else {
                await viewModel.logEvent(
                    type: selectedType,
                    notes: notes.isEmpty ? nil : notes,
                    payload: buildPayload(),
                    occurredAt: occurredAt
                )
            }
            isSaving = false
            dismiss()
        }
    }

    private func buildPayload() -> [String: Any] {
        switch selectedType {
        case .medicine:
            return ["medicineName": medicineName, "doseMg": Double(doseMg) ?? 0.0, "unit": unit]
        case .temperature:
            return ["valueCelsius": Double(tempValue) ?? 0.0, "method": tempMethod]
        case .custom:
            return ["label": customLabel]
        }
    }
}
