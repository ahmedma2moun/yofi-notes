import SwiftUI

extension Color {
    // Brand
    static let mkPrimary      = Color("AccentColor")
    static let mkPrimaryLight = Color(red: 0.92, green: 0.96, blue: 1.00)

    // Surfaces
    static let mkSurface          = Color(.systemBackground)
    static let mkSurfaceSecondary = Color(.secondarySystemBackground)
    static let mkGroupedBg        = Color(.systemGroupedBackground)

    // Text
    static let mkTextPrimary   = Color(.label)
    static let mkTextSecondary = Color(.secondaryLabel)
    static let mkTextTertiary  = Color(.tertiaryLabel)

    // Semantic event colors
    static let mkMedicine    = Color(red: 0.00, green: 0.48, blue: 1.00)
    static let mkTemperature = Color(red: 1.00, green: 0.58, blue: 0.00)
    static let mkCustom      = Color(red: 0.69, green: 0.32, blue: 0.87)
    static let mkSuccess     = Color(red: 0.20, green: 0.78, blue: 0.35)
    static let mkDestructive = Color(.systemRed)
}
