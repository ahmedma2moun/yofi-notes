import Foundation

struct CreateEventRequest: Encodable {
    let type: String
    let notes: String?
    let payload: [String: PayloadValue]?
    let occurredAt: Date?

    enum PayloadValue: Encodable {
        case string(String)
        case double(Double)

        func encode(to encoder: Encoder) throws {
            var c = encoder.singleValueContainer()
            switch self {
            case .string(let s): try c.encode(s)
            case .double(let d): try c.encode(d)
            }
        }
    }
}

actor EventsAPIService {
    static let shared = EventsAPIService()

    func fetchEvents(childId: String, token: String) async throws -> [HealthEvent] {
        try await APIClient.shared.request("GET", path: "children/\(childId)/events", token: token)
    }

    func createEvent(
        childId: String,
        type: EventType,
        notes: String?,
        payload: [String: Any],
        occurredAt: Date,
        token: String
    ) async throws -> HealthEvent {
        let body = CreateEventRequest(
            type: type.rawValue,
            notes: notes,
            payload: encodePayload(payload),
            occurredAt: occurredAt
        )
        return try await APIClient.shared.request(
            "POST", path: "children/\(childId)/events", body: body, token: token
        )
    }

    func updateEvent(
        childId: String,
        eventId: String,
        type: EventType,
        notes: String?,
        payload: [String: Any],
        occurredAt: Date,
        token: String
    ) async throws -> HealthEvent {
        let body = CreateEventRequest(
            type: type.rawValue,
            notes: notes,
            payload: encodePayload(payload),
            occurredAt: occurredAt
        )
        return try await APIClient.shared.request(
            "PATCH", path: "children/\(childId)/events/\(eventId)", body: body, token: token
        )
    }

    func deleteEvent(childId: String, eventId: String, token: String) async throws {
        try await APIClient.shared.requestEmpty(
            "DELETE", path: "children/\(childId)/events/\(eventId)", token: token
        )
    }

    private func encodePayload(_ payload: [String: Any]) -> [String: CreateEventRequest.PayloadValue] {
        payload.compactMapValues { value -> CreateEventRequest.PayloadValue? in
            if let s = value as? String  { return .string(s) }
            if let d = value as? Double  { return .double(d) }
            if let i = value as? Int     { return .double(Double(i)) }
            return nil
        }
    }
}
