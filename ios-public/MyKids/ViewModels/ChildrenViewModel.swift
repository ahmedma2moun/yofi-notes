import Foundation

@MainActor
class ChildrenViewModel: ObservableObject {
    @Published var children: [Child] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let session: AppSession

    init(session: AppSession) {
        self.session = session
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            if session.isLoggedIn {
                children = try await ChildrenAPIService.shared.fetchChildren(token: session.token!)
            } else {
                children = try LocalStore.shared.fetchChildren().map { $0.toChild() }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func addChild(name: String, birthDate: Date?) async {
        do {
            let child: Child
            if session.isLoggedIn {
                child = try await ChildrenAPIService.shared.createChild(
                    name: name, birthDate: birthDate, token: session.token!
                )
            } else {
                let local = try LocalStore.shared.addChild(name: name, birthDate: birthDate)
                child = local.toChild()
            }
            children.append(child)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateChild(_ child: Child, name: String, birthDate: Date?) async {
        do {
            let updated: Child
            if session.isLoggedIn {
                updated = try await ChildrenAPIService.shared.updateChild(
                    id: child.id, name: name, birthDate: birthDate, token: session.token!
                )
            } else {
                try LocalStore.shared.updateChild(id: child.id, name: name, birthDate: birthDate)
                updated = Child(id: child.id, name: name, birthDate: birthDate, ownerId: nil)
            }
            if let idx = children.firstIndex(where: { $0.id == child.id }) {
                children[idx] = updated
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteChild(_ child: Child) async {
        do {
            if session.isLoggedIn {
                try await ChildrenAPIService.shared.deleteChild(id: child.id, token: session.token!)
            } else {
                try LocalStore.shared.deleteChild(id: child.id)
            }
            children.removeAll { $0.id == child.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
