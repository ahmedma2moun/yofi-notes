import Foundation
import Observation

@Observable
final class AppSession {
    enum Mode: Equatable { case guest, loggedIn }

    private(set) var mode: Mode = .guest
    private(set) var currentUser: User?
    private(set) var token: String?

    var isLoggedIn: Bool { mode == .loggedIn }

    // Called after successful login/register
    func signIn(token: String, user: User) {
        self.token = token
        self.currentUser = user
        self.mode = .loggedIn
        persist(token: token, user: user)
    }

    func signOut() {
        token = nil
        currentUser = nil
        mode = .guest
        clearPersisted()
    }

    func continueAsGuest() {
        mode = .guest
    }

    // ── Persistence (Keychain-lite via UserDefaults; swap for Keychain in prod) ──

    func restoreSession() {
        guard
            let token = UserDefaults.standard.string(forKey: "mykids_token"),
            let data  = UserDefaults.standard.data(forKey: "mykids_user"),
            let user  = try? JSONDecoder().decode(User.self, from: data)
        else { return }
        self.token = token
        self.currentUser = user
        self.mode = .loggedIn
    }

    private func persist(token: String, user: User) {
        UserDefaults.standard.set(token, forKey: "mykids_token")
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: "mykids_user")
        }
    }

    private func clearPersisted() {
        UserDefaults.standard.removeObject(forKey: "mykids_token")
        UserDefaults.standard.removeObject(forKey: "mykids_user")
    }
}
