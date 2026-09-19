//
//  Vehicle.swift
//  VehicleDashboardSample
//
//  Created by Akshit on 19/09/26.
//

import Foundation

// MARK: - Vehicle Status

enum VehicleStatus: String, Codable {
    case online  = "ONLINE"
    case offline = "OFFLINE"

    var displayText: String {
        switch self {
        case .online:  return "Online"
        case .offline: return "Offline"
        }
    }

    var isOnline: Bool { self == .online }
}

// MARK: - Vehicle Model

struct Vehicle: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let model: String
    let battery: Int
    let range: Int
    let speed: Int
    let odometer: Int
    let status: VehicleStatus
    let lastUpdated: String

    // MARK: - Computed Helpers

    var lastUpdatedDate: Date? {
        DateParser.parse(lastUpdated)
    }

    var formattedLastUpdated: String {
        guard let date = lastUpdatedDate else { return lastUpdated }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Date Parsing Helpers

private enum DateParser {
    static func parse(_ string: String) -> Date? {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime]
        if let d = iso.date(from: string) { return d }

        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = iso.date(from: string) { return d }

        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return df.date(from: string)
    }
}
