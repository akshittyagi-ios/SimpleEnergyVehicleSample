# Vehicle Dashboard App — iOS Technical Assessment

A two-screen iOS application for monitoring an EV fleet, built with **Swift** and **SwiftUI**.

---

## Architecture

The app follows the **MVVM** pattern with a clean service layer:

```
VehicleDashboardSample/
├── Models/
│   └── Vehicle.swift             # Codable data model + domain helpers
├── Services/
│   └── VehicleService.swift      # Protocol-based data fetching (mock JSON)
├── ViewModels/
│   ├── VehicleListViewModel.swift
│   └── VehicleDetailViewModel.swift
├── Views/
│   ├── VehicleList/
│   │   ├── VehicleListView.swift  # Screen 1
│   │   └── VehicleRowView.swift   # List card component
│   ├── VehicleDetail/
│   │   └── VehicleDetailView.swift # Screen 2
│   └── Components/
│       ├── BatteryBarView.swift
│       ├── StatusBadgeView.swift
│       ├── LoadingView.swift
│       ├── ErrorView.swift
│       └── EmptyStateView.swift
├── DesignSystem/
│   └── DesignSystem.swift         # Colors, Typography, Modifiers
└── Resources/
    └── vehicles.json              # Mock API data
```

---

## Screens

### Screen 1 — Vehicle List
- Displays all vehicles with: **name, model, battery %, range, speed, status (Online/Offline)**
- Animated status badge with pulsating indicator for online vehicles
- Colour-coded animated battery progress bar
- Fleet summary chips showing online/offline counts
- All loading, empty, and error states handled

### Screen 2 — Vehicle Details
- Hero card with gradient background and vehicle icon
- 2-column metrics grid: battery, range, speed, odometer
- Connectivity and model info rows
- **Refresh** toolbar button to reload data
- Last-updated timestamp footer

---

## Data Source

The app consumes a **local mock JSON API** (`vehicles.json` bundled in the app), simulating a real REST response with an 0.8s artificial latency to exercise the loading states.

The data model matches the specification:

```json
{
  "id": 1,
  "name": "Simple One",
  "model": "S1 7 kWh",
  "battery": 72,
  "range": 118,
  "speed": 45,
  "odometer": 5428,
  "status": "ONLINE",
  "lastUpdated": "2026-09-07T10:30:00"
}
```

To swap in a real REST API, replace `VehicleService` with a URLSession-based implementation conforming to `VehicleServiceProtocol` — no other changes needed.

---

## Build Instructions

1. Open `VehicleDashboardSample.xcodeproj` in **Xcode 16+**
2. Select an iPhone simulator (iOS 18.5+) or a physical device
3. Press **⌘R** to build and run

> **No external dependencies** — pure Swift standard library and Apple frameworks only.

---

## Assumptions

- Vehicle data is served from a local bundled JSON file to avoid requiring a running backend
- A simulated 0.8s network delay is applied to demonstrate all view states (loading, success, error)
- The UI targets iOS 18.5+ but uses APIs available since iOS 15 for broad compatibility
- The app uses UIKit's `SceneDelegate` to host the SwiftUI root view (hybrid approach compatible with the existing project structure)

---

## Known Limitations

- The mock service always returns the same static data; a real implementation would use `URLSession` with the provided JSON schema
- No offline caching; subsequent refreshes always hit the (mock) network layer
- The Refresh action on the detail screen re-fetches the same mock data (simulating a network call)
