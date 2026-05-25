import Foundation

private struct RegisterRequest: Encodable {
    let email: String
    let password: String
    let name: String?
}

private struct LoginRequest: Encodable {
    let email: String
    let password: String
}

private struct AuthResponse: Decodable {
    let token: String
    let user: User
}

actor AuthAPIService {
    static let shared = AuthAPIService()

    func register(email: String, password: String, name: String?) async throws -> (String, User) {
        let body = RegisterRequest(email: email, password: password, name: name)
        let res: AuthResponse = try await APIClient.shared.request("POST", path: "auth/register", body: body)
        return (res.token, res.user)
    }

    func login(email: String, password: String) async throws -> (String, User) {
        let body = LoginRequest(email: email, password: password)
        let res: AuthResponse = try await APIClient.shared.request("POST", path: "auth/login", body: body)
        return (res.token, res.user)
    }

    func changePassword(currentPassword: String, newPassword: String, token: String) async throws {
        struct Body: Encodable { let currentPassword: String; let newPassword: String }
        try await APIClient.shared.requestEmpty(
            "PATCH", path: "auth/password",
            body: Body(currentPassword: currentPassword, newPassword: newPassword),
            token: token
        )
    }
}
