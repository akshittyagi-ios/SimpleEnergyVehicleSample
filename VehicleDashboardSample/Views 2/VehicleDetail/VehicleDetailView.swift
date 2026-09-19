//
//  VehicleDetailView.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import SwiftUI

// MARK: - Vehicle Detail View

struct VehicleDetailView: View {

    let vehicleID: Int
    @StateObject private var viewModel: VehicleDetailViewModel

    init(vehicleID: Int) {
        self.vehicleID = vehicleID
        _viewModel = StateObject(wrappedValue: VehicleDetailViewModel(vehicleID: vehicleID))
    }

    var body: some View {
        ZStack {
            Color.bgPrimary.ignoresSafeArea(.all)
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgPrimary.ignoresSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.bgPrimary, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            if case .success(let vehicle) = viewModel.state {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 1) {
                        Text(vehicle.name)
                            .font(.dashboardBody.weight(.semibold))
                            .foregroundStyle(Color.textPrimary)
                        Text(vehicle.model)
                            .font(.dashboardCaption)
                            .foregroundStyle(Color.textSecondary)
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.refresh()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.accentBlue)
                    }
                    .disabled(viewModel.state.isLoading)
                    .accessibilityLabel("Refresh vehicle data")
                }
            }
        }
        .onAppear {
            viewModel.loadVehicle()
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Color.bgPrimary.ignoresSafeArea()

        case .loading:
            LoadingView()
                .overlay(alignment: .top) {
                    Text("Refreshing…")
                        .font(.dashboardCaption)
                        .foregroundStyle(Color.textSecondary)
                        .padding(.top, 16)
                }

        case .success(let vehicle):
            detailScrollView(vehicle)

        case .failure(let message):
            ErrorView(message: message) {
                viewModel.refresh()
            }
        }
    }

    // MARK: - Detail Scroll View

    private func detailScrollView(_ vehicle: Vehicle) -> some View {
        ScrollView {
            VStack(spacing: 20) {

                // Hero section
                heroSection(vehicle)

                // Metrics grid
                metricsGrid(vehicle)

                // Info section
                infoSection(vehicle)

                // Last Updated
                lastUpdatedFooter(vehicle)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Hero Section

    private func heroSection(_ vehicle: Vehicle) -> some View {
        ZStack {
            // Gradient background card
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.brandBlue.opacity(0.8), Color.brandIndigo.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )

            VStack(spacing: 18) {
                // Vehicle icon
                Image(systemName: "scooter")
                    .font(.system(size: 52, weight: .light))
                    .foregroundStyle(Color.white.opacity(0.9))
                    .padding(.top, 8)

                VStack(spacing: 6) {
                    Text(vehicle.name)
                        .font(.dashboardLargeTitle)
                        .foregroundStyle(Color.white)

                    Text(vehicle.model)
                        .font(.dashboardBody)
                        .foregroundStyle(Color.white.opacity(0.75))
                }

                StatusBadgeView(status: vehicle.status)
                    .padding(.bottom, 12)
            }
            .padding(.vertical, 24)
        }
        .shadow(color: Color.brandBlue.opacity(0.4), radius: 16, x: 0, y: 8)
    }

    // MARK: - Metrics Grid

    private func metricsGrid(_ vehicle: Vehicle) -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]

        return LazyVGrid(columns: columns, spacing: 14) {
            MetricCardView(
                icon: "bolt.fill",
                title: "Battery",
                value: "\(vehicle.battery)%",
                color: vehicle.battery.batteryColor,
                accessoryView: AnyView(BatteryBarView(percentage: vehicle.battery).padding(.top, 4))
            )

            MetricCardView(
                icon: "location.fill",
                title: "Range",
                value: "\(vehicle.range) km",
                color: .accentBlue
            )

            MetricCardView(
                icon: "gauge.high",
                title: "Speed",
                value: "\(vehicle.speed) km/h",
                color: Color(hex: "#A78BFA")
            )

            MetricCardView(
                icon: "road.lanes",
                title: "Odometer",
                value: "\(vehicle.odometer.formatted()) km",
                color: Color(hex: "#34D399")
            )
        }
    }

    // MARK: - Info Section

    private func infoSection(_ vehicle: Vehicle) -> some View {
        VStack(spacing: 0) {
            InfoRowView(
                icon: "wifi",
                title: "Connectivity",
                value: vehicle.status.displayText,
                valueColor: vehicle.status.isOnline ? .statusOnline : .statusOffline
            )

            Divider().background(Color.bgTertiary).padding(.leading, 44)

            InfoRowView(
                icon: "car.fill",
                title: "Model",
                value: vehicle.model,
                valueColor: .textSecondary
            )
        }
        .cardStyle()
    }

    // MARK: - Last Updated Footer

    private func lastUpdatedFooter(_ vehicle: Vehicle) -> some View {
        HStack {
            Image(systemName: "clock")
                .font(.dashboardCaption)
                .foregroundStyle(Color.textTertiary)
            Text("Last updated: \(vehicle.formattedLastUpdated)")
                .font(.dashboardCaption)
                .foregroundStyle(Color.textTertiary)
            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Metric Card

private struct MetricCardView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    var accessoryView: AnyView? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(color)
                    .frame(width: 20)
                Text(title)
                    .font(.dashboardCaption)
                    .foregroundStyle(Color.textSecondary)
            }

            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(Color.textPrimary)
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            if let accessory = accessoryView {
                accessory
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

// MARK: - Info Row

private struct InfoRowView: View {
    let icon: String
    let title: String
    let value: String
    let valueColor: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.accentBlue)
                .frame(width: 28)

            Text(title)
                .font(.dashboardBody)
                .foregroundStyle(Color.textSecondary)

            Spacer()

            Text(value)
                .font(.dashboardBody.weight(.semibold))
                .foregroundStyle(valueColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        VehicleDetailView(vehicleID: 1)
    }
}
