//
//  VehicleDashboardApp.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import SwiftUI
import UIKit

@main
struct VehicleDashboardApp: App {

    init() {
        applyGlobalAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentRootView()
        }
    }

    // MARK: - Global UIKit Appearance

    private func applyGlobalAppearance() {
        let bgColor = UIColor(red: 0.059, green: 0.090, blue: 0.161, alpha: 1)

        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = bgColor
        navAppearance.titleTextAttributes       = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes  = [.foregroundColor: UIColor.white]
        navAppearance.shadowColor = .clear

        UINavigationBar.appearance().standardAppearance   = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance    = navAppearance
        UINavigationBar.appearance().tintColor            = UIColor(red: 0.376, green: 0.647, blue: 0.980, alpha: 1) // accentBlue

        UIWindow.appearance().backgroundColor = bgColor
    }
}

// MARK: - Content Root

/// Wraps the list in a ZStack that fills the entire screen including
/// the status bar and home-indicator safe areas.
private struct ContentRootView: View {
    var body: some View {
        ZStack {
            Color(red: 0.059, green: 0.090, blue: 0.161)
                .ignoresSafeArea(.all)
            VehicleListView()
        }
        .onAppear { print(UIScreen.main.bounds) }
        .preferredColorScheme(.dark)
    }
}
