//
//  ErrorView.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import SwiftUI

/// A full-screen error state view with a retry action.
struct ErrorView: View {

    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color(hex: "#F59E0B"))

            VStack(spacing: 8) {
                Text("Something went wrong")
                    .font(.dashboardTitle)
                    .foregroundStyle(Color.textPrimary)

                Text(message)
                    .font(.dashboardBody)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button(action: retryAction) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(.dashboardBody.weight(.semibold))
                    .foregroundStyle(Color.textPrimary)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 13)
                    .background(
                        LinearGradient(
                            colors: [Color.brandBlue, Color.brandIndigo],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary)
    }
}

// MARK: - Preview

#Preview {
    ErrorView(message: "Could not locate the vehicle data source.") {}
}
