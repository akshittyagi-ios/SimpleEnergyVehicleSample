//
//  VehicleService.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import Foundation

// MARK: - Service Errors

enum VehicleServiceError: Error, LocalizedError {
    case resourceNotFound
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .resourceNotFound:
            return "Could not locate the vehicle data source."
        case .decodingFailed(let error):
            return "Failed to parse vehicle data: \(error.localizedDescription)"
        }
    }
}

// MARK: - Vehicle Service Protocol

protocol VehicleServiceProtocol {
    func fetchVehicles() async throws -> [Vehicle]
    func fetchVehicle(id: Int) async throws -> Vehicle
}

// MARK: - Local JSON Vehicle Service


final class VehicleService: VehicleServiceProtocol {

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        return d
    }()

    private let simulatedLatency: TimeInterval = 0.8

    func fetchVehicles() async throws -> [Vehicle] {
        try await Task.sleep(nanoseconds: UInt64(simulatedLatency * 1_000_000_000))
        return try loadFromBundle()
    }

    func fetchVehicle(id: Int) async throws -> Vehicle {
        let all = try await fetchVehicles()
        guard let vehicle = all.first(where: { $0.id == id }) else {
            throw VehicleServiceError.resourceNotFound
        }
        return vehicle
    }

    // MARK: - Private

    private func loadFromBundle() throws -> [Vehicle] {
        guard let url = Bundle.main.url(forResource: "vehicles", withExtension: "json") else {
            throw VehicleServiceError.resourceNotFound
        }
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode([Vehicle].self, from: data)
        } catch let decodingError as DecodingError {
            throw VehicleServiceError.decodingFailed(decodingError)
        }
    }
}
