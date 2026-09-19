//
//  VehicleRowView.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import SwiftUI

/// A single vehicle card displayed in the vehicle list.
struct VehicleRowView: View {

    let vehicle: Vehicle

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: - Header row
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(vehicle.name)
                        .font(.dashboardTitle)
                        .foregroundStyle(Color.textPrimary)
                        .lineLimit(1)

                    Text(vehicle.model)
                        .font(.dashboardLabel)
                        .foregroundStyle(Color.textSecondary)
                }

                Spacer()

                StatusBadgeView(status: vehicle.status)
            }

            Divider()
                .background(Color.bgTertiary)

            // MARK: - Stats row
            HStack(spacing: 0) {
                StatPillView(
                    icon: "bolt.fill",
                    value: "\(vehicle.battery)%",
                    label: "Battery",
                    color: vehicle.battery.batteryColor
                )

                Spacer()

                StatPillView(
                    icon: "location.fill",
                    value: "\(vehicle.range) km",
                    label: "Range",
                    color: .accentBlue
                )

                Spacer()

                StatPillView(
                    icon: "gauge.high",
                    value: "\(vehicle.speed) km/h",
                    label: "Speed",
                    color: Color(hex: "#A78BFA")
                )
            }

            // MARK: - Battery bar
            VStack(alignment: .leading, spacing: 5) {
                BatteryBarView(percentage: vehicle.battery)
            }
        }
        .padding(16)
        .cardStyle()
        .contentShape(Rectangle())
    }
}

// MARK: - Stat Pill

private struct StatPillView: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(color)
                Text(value)
                    .font(.dashboardLabel)
                    .foregroundStyle(Color.textPrimary)
                    .fontWeight(.semibold)
            }
            Text(label)
                .font(.dashboardCaption)
                .foregroundStyle(Color.textTertiary)
        }
    }
}

// MARK: - Preview

#Preview {
    VehicleRowView(vehicle: Vehicle(
        id: 1,
        name: "Simple One",
        model: "S1 7 kWh",
        battery: 72,
        range: 118,
        speed: 45,
        odometer: 5428,
        status: .online,
        lastUpdated: "2026-09-07T10:30:00"
    ))
    .padding()
    .background(Color.bgPrimary)
}
