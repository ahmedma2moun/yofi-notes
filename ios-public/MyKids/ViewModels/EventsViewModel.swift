import Foundation

@MainActor
class EventsViewModel: ObservableObject {
    @Published var events: [HealthEvent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    let child: Child
    private let session: AppSession

    init(child: Child, session: AppSession) {
        self.child = child
        self.session = session
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            if session.isLoggedIn {
                events = try await EventsAPIService.shared.fetchEvents(
                    childId: child.id, token: session.token!
                )
            } else {
                events = try LocalStore.shared.fetchEvents(childId: child.id)
                    .map { $0.toHealthEvent() }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func logEvent(
        type: EventType,
        notes: String?,
        payload: [String: Any],
        occurredAt: Date = Date()
    ) async {
        do {
            let event: HealthEvent
            if session.isLoggedIn {
                event = try await EventsAPIService.shared.createEvent(
                    childId: child.id,
                    type: type,
                    notes: notes,
                    payload: payload,
                    occurredAt: occurredAt,
                    token: session.token!
                )
            } else {
                let local = try LocalStore.shared.addEvent(
                    type: type,
                    childId: child.id,
                    childName: child.name,
                    notes: notes,
                    payload: payload,
                    occurredAt: occurredAt
                )
                event = local.toHealthEvent()
            }
            events.append(event)
            events.sort { $0.occurredAt > $1.occurredAt }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateEvent(
        id: String,
        type: EventType,
        notes: String?,
        payload: [String: Any],
        occurredAt: Date
    ) async {
        do {
            let updated: HealthEvent
            if session.isLoggedIn {
                updated = try await EventsAPIService.shared.updateEvent(
                    childId: child.id,
                    eventId: id,
                    type: type,
                    notes: notes,
                    payload: payload,
                    occurredAt: occurredAt,
                    token: session.token!
                )
            } else {
                try LocalStore.shared.updateEvent(
                    id: id, type: type, notes: notes, payload: payload, occurredAt: occurredAt
                )
                updated = HealthEvent(
                    id: id,
                    type: type,
                    childId: child.id,
                    childName: child.name,
                    notes: notes,
                    occurredAt: occurredAt,
                    payload: nil
                )
            }
            if let idx = events.firstIndex(where: { $0.id == id }) {
                events[idx] = updated
            }
            events.sort { $0.occurredAt > $1.occurredAt }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteEvent(id: String) async {
        do {
            if session.isLoggedIn {
                try await EventsAPIService.shared.deleteEvent(
                    childId: child.id, eventId: id, token: session.token!
                )
            } else {
                try LocalStore.shared.deleteEvent(id: id)
            }
            events.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
