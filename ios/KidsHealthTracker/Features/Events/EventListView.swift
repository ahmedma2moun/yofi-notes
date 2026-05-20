import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel = EventViewModel()
    @State private var showAddEvent = false
    @State private var editingEvent: HealthEvent?
    @State private var eventToDelete: HealthEvent?
    @State private var selectedType: EventType = EventType.allCases[0]

    private var filteredEvents: [HealthEvent] {
        viewModel.events.filter { $0.type == selectedType }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(EventType.allCases, id: \.self) { type in
                            FilterChip(label: type.displayName, isSelected: selectedType == type) {
                                selectedType = type
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .background(.bar)

                if viewModel.isLoading && viewModel.events.isEmpty {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredEvents.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("No Events")
                            .font(.headline)
                        Text("No \(selectedType.displayName) events yet")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(filteredEvents) { event in
                        HStack {
                            EventRowView(event: event)
                            Menu {
                                Button { editingEvent = event } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                Button(role: .destructive) { eventToDelete = event } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(.secondary)
                                    .padding(.vertical, 8)
                                    .padding(.leading, 8)
                            }
                        }
                    }
                    .refreshable { await viewModel.loadEvents() }
                }
            }
            .navigationTitle("Health Tracker")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showAddEvent = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddEvent) {
                AddEventView(viewModel: viewModel)
            }
            .sheet(item: $editingEvent) { event in
                AddEventView(viewModel: viewModel, editingEvent: event)
            }
            .confirmationDialog(
                "Delete Event?",
                isPresented: Binding(get: { eventToDelete != nil }, set: { if !$0 { eventToDelete = nil } }),
                presenting: eventToDelete
            ) { event in
                Button("Delete", role: .destructive) {
                    Task { await viewModel.deleteEvent(id: event.id) }
                }
                Button("Cancel", role: .cancel) {}
            } message: { _ in
                Text("This action cannot be undone.")
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .task { await viewModel.loadEvents() }
        }
    }
}

private struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.accentColor : Color(.secondarySystemBackground))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct EventRowView: View {
    let event: HealthEvent
    @State private var expanded = false

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        f.timeZone = TimeZone(identifier: "Africa/Cairo")
        return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                guard event.notes != nil else { return }
                withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: event.type.systemImage)
                        .font(.title2)
                        .foregroundStyle(iconColor)
                        .frame(width: 36)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(payloadSummary)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(Self.dateFormatter.string(from: event.occurredAt))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if event.notes != nil {
                        Image(systemName: expanded ? "chevron.up" : "chevron.down")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .buttonStyle(.plain)

            if expanded, let notes = event.notes {
                Text(notes)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.leading, 48)
                    .padding(.top, 6)
                    .padding(.bottom, 4)
            }
        }
    }

    private var payloadSummary: String {
        let p = event.payload
        switch event.type {
        case .medicine:
            let name = (p?["medicineName"]?.value as? String) ?? ""
            let dose = p?["doseMg"]?.value
            let unit = (p?["unit"]?.value as? String) ?? ""
            if let d = dose as? Double, d > 0 {
                return "\(name.isEmpty ? "Medicine" : name) — \(Int(d) == Int(exactly: d) ? String(Int(d)) : String(d)) \(unit)"
            }
            return name.isEmpty ? "Medicine" : name
        case .temperature:
            let val = p?["valueCelsius"]?.value
            let method = (p?["method"]?.value as? String) ?? ""
            if let v = val as? Double {
                return "\(v)°C (\(method.capitalized))"
            }
            return "Temperature"
        case .custom:
            return (p?["label"]?.value as? String) ?? "Custom Event"
        }
    }

    private var iconColor: Color {
        switch event.type {
        case .medicine:    return .blue
        case .temperature: return .orange
        case .custom:      return .purple
        }
    }
}
