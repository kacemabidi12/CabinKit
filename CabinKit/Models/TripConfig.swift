import Foundation

enum Climate: String, Codable, CaseIterable, Identifiable {
    case cold, mild, hot
    var id: String { rawValue }

    var label: String {
        switch self {
        case .cold: return "Cold"
        case .mild: return "Mild"
        case .hot: return "Hot"
        }
    }
}

enum DutyType: String, Codable, CaseIterable, Identifiable {
    case shortHaul, longHaul
    var id: String { rawValue }

    var label: String {
        switch self {
        case .shortHaul: return "Short-haul"
        case .longHaul: return "Long-haul"
        }
    }
}

enum AirlineProfile: String, Codable, CaseIterable, Identifiable {
    case generic, emirates
    var id: String { rawValue }

    var label: String {
        switch self {
        case .generic: return "Generic"
        case .emirates: return "Emirates-focused"
        }
    }
}

struct TripConfig: Codable, Equatable {
    var days: Int
    var climate: Climate
    var layovers: Int
    var dutyType: DutyType
    var laundryAccess: Bool
    var carryOnOnly: Bool

    var profile: AirlineProfile
    var groomingKitRequired: Bool
    var spareUniformPieces: Bool

    static var `default`: TripConfig {
        TripConfig(
            days: 3,
            climate: .mild,
            layovers: 1,
            dutyType: .shortHaul,
            laundryAccess: false,
            carryOnOnly: true,
            profile: .emirates,
            groomingKitRequired: true,
            spareUniformPieces: true
        )
    }
}
