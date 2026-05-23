import Foundation
import SwiftData

@MainActor
final class LocalStore {
    static let shared = LocalStore()

    let container: ModelContainer

    private init() {
        let schema = Schema([LocalChild.self, LocalEvent.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        container = try! ModelContainer(for: schema, configurations: [config])
    }

    var context: ModelContext { container.mainContext }

    // ── Children ──────────────────────────────────────────────────────────────

    func fetchChildren() throws -> [LocalChild] {
        let descriptor = FetchDescriptor<LocalChild>(sortBy: [SortDescriptor(\.createdAt)])
        return try context.fetch(descriptor)
    }

    func addChild(name: String, birthDate: Date?) throws -> LocalChild {
        let child = LocalChild(name: name, birthDate: birthDate)
        context.insert(child)
        try context.save()
        return child
    }

    func updateChild(id: String, name: String, birthDate: Date?) throws {
        let descriptor = FetchDescriptor<LocalChild>(
            predicate: #Predicate { $0.id == id }
        )
        guard let child = try context.fetch(descriptor).first else { return }
        child.name = name
        child.birthDate = birthDate
        try context.save()
    }

    func deleteChild(id: String) throws {
        let descriptor = FetchDescriptor<LocalChild>(
            predicate: #Predicate { $0.id == id }
        )
        if let child = try context.fetch(descriptor).first {
            context.delete(child)
            try context.save()
        }
    }

    // ── Events ────────────────────────────────────────────────────────────────

    func fetchEvents(childId: String) throws -> [LocalEvent] {
        let descriptor = FetchDescriptor<LocalEvent>(
            predicate: #Predicate { $0.childId == childId },
            sortBy: [SortDescriptor(\.occurredAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    func addEvent(
        type: EventType,
        childId: String,
        childName: String,
        notes: String?,
        payload: [String: Any],
        occurredAt: Date
    ) throws -> LocalEvent {
        let event = LocalEvent(
            type: type,
            childId: childId,
            childName: childName,
            notes: notes,
            occurredAt: occurredAt,
            payload: payload
        )
        context.insert(event)
        try context.save()
        return event
    }

    func updateEvent(
        id: String,
        type: EventType,
        notes: String?,
        payload: [String: Any],
        occurredAt: Date
    ) throws {
        let descriptor = FetchDescriptor<LocalEvent>(
            predicate: #Predicate { $0.id == id }
        )
        guard let event = try context.fetch(descriptor).first else { return }
        event.typeRaw = type.rawValue
        event.notes = notes
        event.occurredAt = occurredAt
        if let data = try? JSONSerialization.data(withJSONObject: payload) {
            event.payloadData = data
        }
        try context.save()
    }

    func deleteEvent(id: String) throws {
        let descriptor = FetchDescriptor<LocalEvent>(
            predicate: #Predicate { $0.id == id }
        )
        if let event = try context.fetch(descriptor).first {
            context.delete(event)
            try context.save()
        }
    }
}
