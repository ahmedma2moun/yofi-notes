import Foundation

struct Child: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let birthDate: Date?
    let ownerId: String?

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: Child, rhs: Child) -> Bool { lhs.id == rhs.id }
}
