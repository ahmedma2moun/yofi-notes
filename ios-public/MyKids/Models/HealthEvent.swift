import Foundation

struct HealthEvent: Codable, Identifiable {
    let id: String
    let type: EventType
    let childId: String?
    let childName: String
    let notes: String?
    let occurredAt: Date
    let payload: [String: AnyCodable]?
}

struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) { self.value = value }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let b = try? container.decode(Bool.self)   { value = b; return }
        if let d = try? container.decode(Double.self) { value = d; return }
        if let s = try? container.decode(String.self) { value = s; return }
        value = NSNull()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let v as Int:    try container.encode(v)
        case let v as Double: try container.encode(v)
        case let v as Bool:   try container.encode(v)
        case let v as String: try container.encode(v)
        default:              try container.encodeNil()
        }
    }
}
