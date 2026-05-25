import SwiftUI

struct EventListView: View {
    let child: Child
    @StateObject private var viewModel: EventsViewModel
    @Environment(AppSession.self) private var session

    @State private var showAddEvent  = false
    @State private var editingEvent: HealthEvent?
    @State private var eventToDelete: HealthEvent?
    @State private var selectedType: EventType = EventType.allCases[0]
    @State private var showShare = false

    @State private var expandedDays: Set<String> = {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
        return [f.string(from: Date())]
    }()

    private static let daySectionFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"; return f
    }()
    private static let dayDisplayFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateStyle = .long; f.timeStyle = .none; return f
    }()

    init(child: Child, session: AppSession) {
        self.child = child
        _viewModel = StateObject(wrappedValue: EventsViewModel(child: child, session: session))
    }

    private var filteredEvents: [HealthEvent] {
        viewModel.events.filter { $0.type == selectedType }
    }

    private var eventsByDay: [(dayKey: String, date: Date, events: [HealthEvent])] {
        let cal = Calendar.current
        let grouped = Dictionary(grouping: filteredEvents) { cal.startOfDay(for: $0.occurredAt) }
        return grouped
            .sorted { $0.key > $1.key }
            .map { (day, events) in
                (dayKey: Self.daySectionFormatter.string(from: day),
                 date: day,
                 events: events.sorted { $0.occurredAt > $1.occurredAt })
            }
    }

    private func dayLabel(for date: Date) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(date)     { return "Today" }
        if cal.isDateInYesterday(date) { return "Yesterday" }
        return Self.dayDisplayFormatter.string(from: date)
    }

    var body: some View {
        VStack(spacing: 0) {
            typeFilterBar

            if viewModel.isLoading && viewModel.events.isEmpty {
                ProgressView("Loading…").frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filteredEvents.isEmpty {
                emptyState
            } else {
                eventList
            }
        }
        .navigationTitle(child.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showAddEvent = true } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Log event")
            }
            if session.isLoggedIn && child.ownerId == session.currentUser?.id {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showShare = true } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityLabel("Share \(child.name)")
                }
            }
        }
        .sheet(isPresented: $showAddEvent) {
            AddEventView(viewModel: viewModel)
        }
        .sheet(item: $editingEvent) { event in
            AddEventView(viewModel: viewModel, editingEvent: event)
        }
        .sheet(isPresented: $showShare) {
            ShareChildView(child: child, session: session)
        }
        .confirmationDialog(
            "Delete Event?",
            isPresented: Binding(
                get: { eventToDelete != nil },
                set: { if !$0 { eventToDelete = nil } }
            ),
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
        .task { await viewModel.load() }
    }

    private var typeFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(EventType.allCases, id: \.self) { type in
                    FilterChip(label: type.displayName, isSelected: selectedType == type) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedType = type
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(.bar)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(Color.mkTextTertiary)
                .symbolRenderingMode(.hierarchical)
            Text("No Events")
                .font(.headline)
            Text("No \(selectedType.displayName) events yet")
                .font(.subheadline)
                .foregroundStyle(Color.mkTextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var eventList: some View {
        List {
            ForEach(eventsByDay, id: \.dayKey) { group in
                Section {
                    if expandedDays.contains(group.dayKey) {
                        ForEach(group.events) { event in
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
                                        .foregroundStyle(Color.mkTextSecondary)
                                        .padding(.vertical, 8)
                                        .padding(.leading, 8)
                                }
                                .accessibilityLabel("Event options")
                            }
                            .accessibilityElement(children: .combine)
                        }
                    }
                } header: {
                    HStack {
                        Text(dayLabel(for: group.date))
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .textCase(nil)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundStyle(Color.mkTextSecondary)
                            .rotationEffect(.degrees(expandedDays.contains(group.dayKey) ? 0 : -90))
                            .animation(.easeInOut(duration: 0.2), value: expandedDays)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if expandedDays.contains(group.dayKey) {
                                expandedDays.remove(group.dayKey)
                            } else {
                                expandedDays.insert(group.dayKey)
                            }
                        }
                    }
                }
            }
        }
        .refreshable { await viewModel.load() }
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
                .background(isSelected ? Color.mkPrimary : Color.mkSurfaceSecondary)
                .foregroundStyle(isSelected ? Color.white : Color.mkTextPrimary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct EventRowView: View {
    let event: HealthEvent
    @State private var expanded = false

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter(); f.timeStyle = .short; f.dateStyle = .none; return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                guard event.notes != nil else { return }
                withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() }
            } label: {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 9)
                            .fill(iconColor.opacity(0.12))
                            .frame(width: 36, height: 36)
                        Image(systemName: event.type.systemImage)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(iconColor)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(payloadSummary)
                            .font(.headline)
                            .foregroundStyle(Color.mkTextPrimary)
                        Text(Self.timeFormatter.string(from: event.occurredAt))
                            .font(.caption)
                            .foregroundStyle(Color.mkTextSecondary)
                    }

                    Spacer()

                    if event.notes != nil {
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundStyle(Color.mkTextSecondary)
                            .rotationEffect(.degrees(expanded ? 180 : 0))
                            .animation(.easeInOut(duration: 0.2), value: expanded)
                    }
                }
                .padding(.vertical, 4)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("\(event.type.displayName), \(payloadSummary), \(Self.timeFormatter.string(from: event.occurredAt))")

            if expanded, let notes = event.notes {
                Text(notes)
                    .font(.subheadline)
                    .foregroundStyle(Color.mkTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(Color.mkSurfaceSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 6)
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
                return "\(name.isEmpty ? "Medicine" : name) — \(d == Double(Int(d)) ? String(Int(d)) : String(d)) \(unit)"
            }
            return name.isEmpty ? "Medicine" : name
        case .temperature:
            if let v = p?["valueCelsius"]?.value as? Double {
                let method = (p?["method"]?.value as? String) ?? ""
                return "\(v)°C (\(method.capitalized))"
            }
            return "Temperature"
        case .custom:
            return (p?["label"]?.value as? String) ?? "Custom Event"
        }
    }

    private var iconColor: Color {
        switch event.type {
        case .medicine:    return .mkMedicine
        case .temperature: return .mkTemperature
        case .custom:      return .mkCustom
        }
    }
}
