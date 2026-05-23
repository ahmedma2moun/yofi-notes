import Foundation

enum EventType: String, Codable, CaseIterable {
    case medicine    = "MEDICINE"
    case temperature = "TEMPERATURE"
    case custom      = "CUSTOM"

    var displayName: String {
        switch self {
        case .medicine:    return "Medicine"
        case .temperature: return "Temperature"
        case .custom:      return "Custom Event"
        }
    }

    var systemImage: String {
        switch self {
        case .medicine:    return "pill.fill"
        case .temperature: return "thermometer.medium"
        case .custom:      return "star.fill"
        }
    }
}
