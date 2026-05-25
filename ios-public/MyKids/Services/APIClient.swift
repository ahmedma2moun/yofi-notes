import Foundation

enum APIError: LocalizedError {
    case httpError(Int, String)
    case decodingError(Error)
    case noToken

    var errorDescription: String? {
        switch self {
        case .httpError(let code, _):
            switch code {
            case 400: return "Please check your details and try again."
            case 401: return "Incorrect email or password."
            case 409: return "An account with this email already exists."
            default:  return "Something went wrong. Please try again."
            }
        case .decodingError: return "Something went wrong. Please try again."
        case .noToken:       return "You're not signed in. Please log in again."
        }
    }
}

actor APIClient {
    static let shared = APIClient()

    let baseURL = URL(string: "https://yofi-notes-guq8.vercel.app")!

    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    func request<T: Decodable>(
        _ method: String,
        path: String,
        body: Encodable? = nil,
        token: String? = nil
    ) async throws -> T {
        var req = URLRequest(url: baseURL.appendingPathComponent(path))
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token { req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }
        if let body  { req.httpBody = try encoder.encode(body) }

        let (data, response) = try await URLSession.shared.data(for: req)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0

        guard (200..<300).contains(statusCode) else {
            let message = (try? JSONDecoder().decode([String: String].self, from: data))?["message"]
                ?? String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.httpError(statusCode, message)
        }

        do { return try decoder.decode(T.self, from: data) }
        catch { throw APIError.decodingError(error) }
    }

    func requestEmpty(
        _ method: String,
        path: String,
        body: Encodable? = nil,
        token: String? = nil
    ) async throws {
        var req = URLRequest(url: baseURL.appendingPathComponent(path))
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token { req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }
        if let body  { req.httpBody = try encoder.encode(body) }

        let (_, response) = try await URLSession.shared.data(for: req)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        guard (200..<300).contains(statusCode) else {
            throw APIError.httpError(statusCode, "Request failed")
        }
    }
}
