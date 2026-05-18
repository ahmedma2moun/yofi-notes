import Foundation

struct HealthEvent: Codable, Identifiable {
    let id: String
    let type: EventType
    let childName: String
    let notes: String?
    let occurredAt: Date
    let payload: [String: AnyCodable]?
}

// Wrapper to allow heterogeneous JSON payloads to be Codable
struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else {
            value = NSNull()
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case let intValue as Int:       try container.encode(intValue)
        case let doubleValue as Double: try container.encode(doubleValue)
        case let boolValue as Bool:     try container.encode(boolValue)
        case let stringValue as String: try container.encode(stringValue)
        default:                        try container.encodeNil()
        }
    }
}
