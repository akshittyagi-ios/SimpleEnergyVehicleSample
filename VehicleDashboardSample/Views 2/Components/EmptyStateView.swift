//
//  EmptyStateView.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import SwiftUI

/// Shown when the vehicle list returns empty.
struct EmptyStateView: View {

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "car.fill")
                .font(.system(size: 52))
                .foregroundStyle(Color.textTertiary)

            Text("No Vehicles Found")
                .font(.dashboardTitle)
                .foregroundStyle(Color.textPrimary)

            Text("Your fleet will appear here once vehicles are connected.")
                .font(.dashboardBody)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary)
    }
}

// MARK: - Preview

#Preview {
    EmptyStateView()
}
