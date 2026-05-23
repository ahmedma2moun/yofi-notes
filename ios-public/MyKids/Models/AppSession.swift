import Foundation
import Observation

@Observable
final class AppSession {
    enum Mode: Equatable { case welcome, guest, loggedIn }

    private(set) var mode: Mode = .welcome
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
        mode = .welcome
        clearPersisted()
    }

    func continueAsGuest() {
        mode = .guest
        UserDefaults.standard.set(true, forKey: "mykids_guest_chosen")
    }

    // ── Persistence (Keychain-lite via UserDefaults; swap for Keychain in prod) ──

    func restoreSession() {
        // Returning logged-in user
        if let token = UserDefaults.standard.string(forKey: "mykids_token"),
           let data  = UserDefaults.standard.data(forKey: "mykids_user"),
           let user  = try? JSONDecoder().decode(User.self, from: data) {
            self.token = token
            self.currentUser = user
            self.mode = .loggedIn
            return
        }
        // Returning guest user
        if UserDefaults.standard.bool(forKey: "mykids_guest_chosen") {
            self.mode = .guest
            return
        }
        // First launch — show welcome screen
        self.mode = .welcome
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
