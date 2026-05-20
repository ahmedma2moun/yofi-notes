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
        let encodablePayload = payload.compactMapValues { value -> CreateEventRequest.PayloadValue? in
            if let s = value as? String { return .string(s) }
            if let d = value as? Double { return .double(d) }
            if let i = value as? Int { return .double(Double(i)) }
            return nil
        }

        let request = CreateEventRequest(
            type: type.rawValue,
            childName: childName,
            notes: notes,
            payload: encodablePayload,
            occurredAt: occurredAt
        )

        do {
            let newEvent = try await APIService.shared.logEvent(request)
            events.append(newEvent)
            events.sort { $0.occurredAt > $1.occurredAt }
        } catch {
            errorMessage = "Failed to log event: \(error.localizedDescription)"
        }
    }
}
