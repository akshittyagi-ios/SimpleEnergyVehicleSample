//
//  VehicleListView.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import SwiftUI

// MARK: - Vehicle List View

struct VehicleListView: View {

    @StateObject private var viewModel = VehicleListViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.059, green: 0.090, blue: 0.161)
                    .ignoresSafeArea(.all)
                content
            }
            .navigationTitle("My Fleet")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.loadVehicles()
            }
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

        case .success(let vehicles):
            if vehicles.isEmpty {
                EmptyStateView()
            } else {
                vehicleList(vehicles)
            }

        case .failure(let message):
            ErrorView(message: message) {
                viewModel.loadVehicles()
            }
        }
    }

    // MARK: - Vehicle List

    private func vehicleList(_ vehicles: [Vehicle]) -> some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                // Online / Offline section summary chips
                summaryHeader(vehicles: vehicles)
                    .padding(.top, 4)

                ForEach(vehicles) { vehicle in
                    NavigationLink(destination: VehicleDetailView(vehicleID: vehicle.id)) {
                        VehicleRowView(vehicle: vehicle)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("vehicleRow_\(vehicle.id)")
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Summary Header

    private func summaryHeader(vehicles: [Vehicle]) -> some View {
        HStack(spacing: 10) {
            let onlineCount  = vehicles.filter { $0.status.isOnline }.count
            let offlineCount = vehicles.count - onlineCount

            SummaryChipView(count: onlineCount,  label: "Online",  color: .statusOnline)
            SummaryChipView(count: offlineCount, label: "Offline", color: .statusOffline)
            Spacer()

            Text("\(vehicles.count) vehicles")
                .font(.dashboardCaption)
                .foregroundStyle(Color.textTertiary)
        }
    }
}

// MARK: - Summary Chip

private struct SummaryChipView: View {
    let count: Int
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 7, height: 7)
            Text("\(count) \(label)")
                .font(.dashboardCaption)
                .foregroundStyle(Color.textSecondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.bgSecondary)
        .clipShape(Capsule())
    }
}

// MARK: - Preview

#Preview {
    VehicleListView()
}
