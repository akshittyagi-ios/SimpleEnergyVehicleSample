//
//  LoadingView.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import SwiftUI

/// Full-screen loading indicator used while fetching data.
struct LoadingView: View {

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Color.bgTertiary, lineWidth: 4)
                    .frame(width: 56, height: 56)

                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [Color.accentBlue, Color.brandBlue],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 56, height: 56)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                    .onAppear { isAnimating = true }
            }

            Text("Loading vehicles…")
                .font(.dashboardBody)
                .foregroundStyle(Color.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary)
    }
}

// MARK: - Preview

#Preview {
    LoadingView()
}
