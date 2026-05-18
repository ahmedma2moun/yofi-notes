import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel = EventViewModel()
    @State private var showAddEvent = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.events.isEmpty {
                    ProgressView("Loading…")
                } else if viewModel.events.isEmpty {
                    ContentUnavailableView(
                        "No Events",
                        systemImage: "heart.text.clipboard",
                        description: Text("Tap + to log a health event")
                    )
                } else {
                    List(viewModel.events) { event in
                        EventRowView(event: event)
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

struct EventRowView: View {
    let event: HealthEvent

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: event.type.systemImage)
                .font(.title2)
                .foregroundStyle(iconColor)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(event.childName)
                    .font(.headline)
                Text(event.type.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let notes = event.notes {
                    Text(notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Text(Self.dateFormatter.string(from: event.occurredAt))
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
    }

    private var iconColor: Color {
        switch event.type {
        case .medicine:    return .blue
        case .temperature: return .orange
        case .custom:      return .purple
        }
    }
}
