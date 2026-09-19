//
//  StatusBadgeView.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import SwiftUI

/// An Online / Offline pill badge with an animated presence dot.
struct StatusBadgeView: View {

    let status: VehicleStatus

    private var color: Color {
        status.isOnline ? .statusOnline : .statusOffline
    }

    var body: some View {
        HStack(spacing: 5) {
            // Animated pulse dot for online vehicles
            ZStack {
                if status.isOnline {
                    Circle()
                        .fill(color.opacity(0.35))
                        .frame(width: 10, height: 10)
                        .scaleEffect(pulseScale)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: pulseScale)
                        .onAppear { pulseScale = 1.5 }
                }
                Circle()
                    .fill(color)
                    .frame(width: 7, height: 7)
            }

            Text(status.displayText)
                .font(.dashboardCaption)
                .foregroundStyle(color)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
    }

    @State private var pulseScale: CGFloat = 1.0
}

// MARK: - Preview

#Preview {
    HStack(spacing: 16) {
        StatusBadgeView(status: .online)
        StatusBadgeView(status: .offline)
    }
    .padding()
    .background(Color.bgPrimary)
}
