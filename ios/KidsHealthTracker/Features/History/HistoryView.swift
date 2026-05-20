import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = EventViewModel()

    private let groupedByDate: [(String, [HealthEvent])] = []

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.events.isEmpty {
                    ProgressView("Loading…")
                } else if viewModel.events.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("No History")
                            .font(.headline)
                        Text("Events you log will appear here")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(groupedEvents, id: \.0) { dateString, events in
                            Section(dateString) {
                                ForEach(events) { event in
                                    EventRowView(event: event)
                                }
                            }
                        }
                    }
                    .refreshable { await viewModel.loadEvents() }
                }
            }
            .navigationTitle("History")
            .task { await viewModel.loadEvents() }
        }
    }

    private var groupedEvents: [(String, [HealthEvent])] {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        formatter.timeZone = TimeZone(identifier: "Africa/Cairo")

        let grouped = Dictionary(grouping: viewModel.events) { event in
            formatter.string(from: event.occurredAt)
        }
        return grouped
            .sorted { $0.key > $1.key }
            .map { ($0.key, $0.value) }
    }
}
