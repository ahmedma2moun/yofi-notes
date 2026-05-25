import Foundation

struct GuestDataSyncer {
    /// Uploads all locally stored children and their events to the API.
    /// Errors for individual items are silently skipped so a partial sync never
    /// blocks sign-in.
    @MainActor
    static func sync(token: String) async {
        let localChildren = (try? LocalStore.shared.fetchChildren()) ?? []
        guard !localChildren.isEmpty else { return }

        for localChild in localChildren {
            guard let apiChild = try? await ChildrenAPIService.shared.createChild(
                name: localChild.name,
                birthDate: localChild.birthDate,
                token: token
            ) else { continue }

            let localEvents = (try? LocalStore.shared.fetchEvents(childId: localChild.id)) ?? []
            for event in localEvents {
                let payload: [String: Any] = event.payloadData
                    .flatMap { try? JSONSerialization.jsonObject(with: $0) as? [String: Any] }
                    ?? [:]
                _ = try? await EventsAPIService.shared.createEvent(
                    childId: apiChild.id,
                    type: event.type,
                    notes: event.notes,
                    payload: payload,
                    occurredAt: event.occurredAt,
                    token: token
                )
            }
        }
    }
}
