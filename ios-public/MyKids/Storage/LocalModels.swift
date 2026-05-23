import Foundation
import SwiftData

@Model
final class LocalChild {
    @Attribute(.unique) var id: String
    var name: String
    var birthDate: Date?
    var createdAt: Date

    @Relationship(deleteRule: .cascade) var events: [LocalEvent] = []

    init(id: String = UUID().uuidString, name: String, birthDate: Date? = nil) {
        self.id = id
        self.name = name
        self.birthDate = birthDate
        self.createdAt = Date()
    }

    func toChild() -> Child {
        Child(id: id, name: name, birthDate: birthDate, ownerId: nil)
    }
}

@Model
final class LocalEvent {
    @Attribute(.unique) var id: String
    var typeRaw: String
    var childId: String
    var childName: String
    var notes: String?
    var occurredAt: Date
    var createdAt: Date
    var payloadData: Data?

    var type: EventType { EventType(rawValue: typeRaw) ?? .custom }

    init(
        id: String = UUID().uuidString,
        type: EventType,
        childId: String,
        childName: String,
        notes: String? = nil,
        occurredAt: Date = Date(),
        payload: [String: Any]? = nil
    ) {
        self.id = id
        self.typeRaw = type.rawValue
        self.childId = childId
        self.childName = childName
        self.notes = notes
        self.occurredAt = occurredAt
        self.createdAt = Date()
        if let p = payload, let data = try? JSONSerialization.data(withJSONObject: p) {
            self.payloadData = data
        }
    }

    func toHealthEvent() -> HealthEvent {
        let payload: [String: AnyCodable]? = payloadData
            .flatMap { try? JSONSerialization.jsonObject(with: $0) as? [String: Any] }
            .map { dict in dict.compactMapValues { AnyCodable($0) } }

        return HealthEvent(
            id: id,
            type: type,
            childId: childId,
            childName: childName,
            notes: notes,
            occurredAt: occurredAt,
            payload: payload
        )
    }
}
