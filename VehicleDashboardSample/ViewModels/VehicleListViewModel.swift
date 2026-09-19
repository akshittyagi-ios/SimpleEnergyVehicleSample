//
//  VehicleListViewModel.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import Foundation
import Combine

// MARK: - View State

enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case failure(String)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

// MARK: - VehicleListViewModel

@MainActor
final class VehicleListViewModel: ObservableObject {

    // MARK: Published

    @Published private(set) var state: ViewState<[Vehicle]> = .idle

    // MARK: Dependencies

    private let service: VehicleServiceProtocol

    // MARK: Init

    init(service: VehicleServiceProtocol = VehicleService()) {
        self.service = service
    }

    // MARK: Intent

    func loadVehicles() {
        guard !state.isLoading else { return }
        state = .loading
        Task {
            do {
                let vehicles = try await service.fetchVehicles()
                state = vehicles.isEmpty ? .success([]) : .success(vehicles)
            } catch {
                state = .failure(error.localizedDescription)
            }
        }
    }
}
