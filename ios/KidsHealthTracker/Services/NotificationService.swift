import Foundation
import UserNotifications

// Utility for requesting and checking local notification permission.
// FCM registration is handled in AppDelegate via Firebase SDK.
enum NotificationService {
    static func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
        return granted ?? false
    }

    static func currentAuthorizationStatus() async -> UNAuthorizationStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return settings.authorizationStatus
    }
}
