import Foundation

private struct CreateChildBody: Encodable {
    let name: String
    let birthDate: String?
}

private struct UpdateChildBody: Encodable {
    let name: String?
    let birthDate: String?
}

struct InviteResponse: Decodable {
    let code: String
    let expiresAt: Date?
}

actor ChildrenAPIService {
    static let shared = ChildrenAPIService()

    private let iso8601: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate]
        return f
    }()

    func fetchChildren(token: String) async throws -> [Child] {
        try await APIClient.shared.request("GET", path: "children", token: token)
    }

    func createChild(name: String, birthDate: Date?, token: String) async throws -> Child {
        let body = CreateChildBody(
            name: name,
            birthDate: birthDate.map { iso8601.string(from: $0) }
        )
        return try await APIClient.shared.request("POST", path: "children", body: body, token: token)
    }

    func updateChild(id: String, name: String, birthDate: Date?, token: String) async throws -> Child {
        let body = UpdateChildBody(
            name: name,
            birthDate: birthDate.map { iso8601.string(from: $0) }
        )
        return try await APIClient.shared.request("PATCH", path: "children/\(id)", body: body, token: token)
    }

    func deleteChild(id: String, token: String) async throws {
        try await APIClient.shared.requestEmpty("DELETE", path: "children/\(id)", token: token)
    }

    func generateInvite(childId: String, token: String) async throws -> InviteResponse {
        try await APIClient.shared.request("POST", path: "children/\(childId)/invite", token: token)
    }

    func acceptInvite(code: String, token: String) async throws -> Child {
        struct Body: Encodable { let code: String }
        return try await APIClient.shared.request(
            "POST", path: "children/accept-invite", body: Body(code: code), token: token
        )
    }
}
