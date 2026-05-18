import Foundation

// Request model sent when logging a new health event
struct CreateEventRequest: Encodable {
    let type: String
    let childName: String
    let notes: String?
    let payload: [String: PayloadValue]?
    let occurredAt: Date?

    enum PayloadValue: Encodable {
        case string(String)
        case double(Double)

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let s): try container.encode(s)
            case .double(let d): try container.encode(d)
            }
        }
    }
}

actor APIService {
    static let shared = APIService()

    // Replace with your server's IP/hostname before building
    private let baseURL = URL(string: "http://localhost:3000")!

    func registerDevice(fcmToken: String) async {
        let url = baseURL.appendingPathComponent("devices/register")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["fcmToken": fcmToken])
        _ = try? await URLSession.shared.data(for: request)
    }

    func logEvent(_ event: CreateEventRequest) async throws -> HealthEvent {
        let url = baseURL.appendingPathComponent("events")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(event)

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(HealthEvent.self, from: data)
    }

    func fetchEvents() async throws -> [HealthEvent] {
        let url = baseURL.appendingPathComponent("events")
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([HealthEvent].self, from: data)
    }
}
