import Foundation
import SwiftUI

@MainActor
class EventViewModel: ObservableObject {
    @Published var events: [HealthEvent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadEvents() async {
        isLoading = true
        errorMessage = nil
        do {
            events = try await APIService.shared.fetchEvents()
            events.sort { $0.occurredAt > $1.occurredAt }
        } catch {
            errorMessage = "Failed to load events: \(error.localizedDescription)"
        }
        isLoading = false
    }

    func logEvent(
        type: EventType,
        childName: String,
        notes: String?,
        payload: [String: Any],
        occurredAt: Date = Date()
    ) async {
        do {
            let newEvent = try await APIService.shared.logEvent(buildRequest(type: type, childName: childName, notes: notes, payload: payload, occurredAt: occurredAt))
            events.append(newEvent)
            events.sort { $0.occurredAt > $1.occurredAt }
        } catch {
            errorMessage = "Failed to log event: \(error.localizedDescription)"
        }
    }

    func updateEvent(
        id: String,
        type: EventType,
        childName: String,
        notes: String?,
        payload: [String: Any],
        occurredAt: Date
    ) async {
        do {
            let updated = try await APIService.shared.updateEvent(id: id, buildRequest(type: type, childName: childName, notes: notes, payload: payload, occurredAt: occurredAt))
            if let idx = events.firstIndex(where: { $0.id == id }) {
                events[idx] = updated
            }
            events.sort { $0.occurredAt > $1.occurredAt }
        } catch {
            errorMessage = "Failed to update event: \(error.localizedDescription)"
        }
    }

    func deleteEvent(id: String) async {
        do {
            try await APIService.shared.deleteEvent(id: id)
            events.removeAll { $0.id == id }
        } catch {
            errorMessage = "Failed to delete event: \(error.localizedDescription)"
        }
    }

    private func buildRequest(
        type: EventType,
        childName: String,
        notes: String?,
        payload: [String: Any],
        occurredAt: Date
    ) -> CreateEventRequest {
        let encodablePayload = payload.compactMapValues { value -> CreateEventRequest.PayloadValue? in
            if let s = value as? String { return .string(s) }
            if let d = value as? Double { return .double(d) }
            if let i = value as? Int { return .double(Double(i)) }
            return nil
        }
        return CreateEventRequest(
            type: type.rawValue,
            childName: childName,
            notes: notes,
            payload: encodablePayload,
            occurredAt: occurredAt
        )
    }
}
