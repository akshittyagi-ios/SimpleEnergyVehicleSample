//
//  VehicleDetailViewModel.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import Foundation

// MARK: - VehicleDetailViewModel

@MainActor
final class VehicleDetailViewModel: ObservableObject {

    // MARK: Published

    @Published private(set) var state: ViewState<Vehicle> = .idle

    // MARK: Properties

    let vehicleID: Int
    private let service: VehicleServiceProtocol

    // MARK: Init

    init(vehicleID: Int, service: VehicleServiceProtocol = VehicleService()) {
        self.vehicleID = vehicleID
        self.service = service
    }

    // MARK: Intent

    func loadVehicle() {
        guard !state.isLoading else { return }
        state = .loading
        Task {
            do {
                let vehicle = try await service.fetchVehicle(id: vehicleID)
                state = .success(vehicle)
            } catch {
                state = .failure(error.localizedDescription)
            }
        }
    }

    func refresh() {
        state = .loading
        Task {
            do {
                let vehicle = try await service.fetchVehicle(id: vehicleID)
                state = .success(vehicle)
            } catch {
                state = .failure(error.localizedDescription)
            }
        }
    }
}
