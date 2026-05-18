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
                    ContentUnavailableView(
                        "No History",
                        systemImage: "clock.arrow.circlepath",
                        description: Text("Events you log will appear here")
                    )
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

        let grouped = Dictionary(grouping: viewModel.events) { event in
            formatter.string(from: event.occurredAt)
        }
        return grouped
            .sorted { $0.key > $1.key }
            .map { ($0.key, $0.value) }
    }
}
