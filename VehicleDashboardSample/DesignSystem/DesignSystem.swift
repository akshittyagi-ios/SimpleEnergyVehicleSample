//
//  DesignSystem.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import SwiftUI

// MARK: - Color Palette

extension Color {
    static let brandBlue     = Color(hex: "#1E40AF")
    static let brandIndigo   = Color(hex: "#3730A3")

    static let bgPrimary     = Color(hex: "#0F172A")
    static let bgSecondary   = Color(hex: "#1E293B")
    static let bgTertiary    = Color(hex: "#334155")

    static let statusOnline  = Color(hex: "#22C55E")
    static let statusOffline = Color(hex: "#94A3B8")

    static let batteryHigh   = Color(hex: "#22C55E")
    static let batteryMid    = Color(hex: "#F59E0B")
    static let batteryLow    = Color(hex: "#EF4444")

    static let textPrimary   = Color.white
    static let textSecondary = Color(hex: "#94A3B8")
    static let textTertiary  = Color(hex: "#64748B")

    static let accentBlue    = Color(hex: "#60A5FA")

    // MARK: - Hex Init

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:(a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red:   Double(r) / 255,
                  green: Double(g) / 255,
                  blue:  Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// MARK: - Battery Color Helper

extension Int {
    var batteryColor: Color {
        switch self {
        case 61...: return .batteryHigh
        case 20...60: return .batteryMid
        default:    return .batteryLow
        }
    }
}

// MARK: - Typography

extension Font {
    static let dashboardLargeTitle = Font.system(size: 28, weight: .bold, design: .rounded)
    static let dashboardTitle      = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let dashboardBody       = Font.system(size: 15, weight: .regular, design: .rounded)
    static let dashboardCaption    = Font.system(size: 12, weight: .medium, design: .rounded)
    static let dashboardLabel      = Font.system(size: 13, weight: .medium, design: .rounded)
    static let dashboardMetric     = Font.system(size: 32, weight: .bold, design: .rounded)
}

// MARK: - View Modifiers

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.bgSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}
