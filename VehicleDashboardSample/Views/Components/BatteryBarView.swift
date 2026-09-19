//
//  BatteryBarView.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import SwiftUI

struct BatteryBarView: View {

    let percentage: Int

    private var fillFraction: Double {
        Double(max(0, min(100, percentage))) / 100.0
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(Color.bgTertiary)

                // Fill
                RoundedRectangle(cornerRadius: 3, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [percentage.batteryColor.opacity(0.7), percentage.batteryColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * fillFraction)
                    .animation(.easeInOut(duration: 0.5), value: percentage)
            }
        }
        .frame(height: 5)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        BatteryBarView(percentage: 85)
        BatteryBarView(percentage: 45)
        BatteryBarView(percentage: 12)
    }
    .padding()
    .background(Color.bgPrimary)
}
