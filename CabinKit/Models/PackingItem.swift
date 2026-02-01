import Foundation

enum PackingCategory: String, Codable, CaseIterable, Identifiable {
    case documents
    case uniform
    case footwear
    case grooming
    case toiletries
    case tech
    case health
    case crewEssentials
    case layoverExtras

    var id: String { rawValue }

    var label: String {
        switch self {
        case .documents: return "Documents"
        case .uniform: return "Uniform & Presentation"
        case .footwear: return "Footwear"
        case .grooming: return "Grooming Kit"
        case .toiletries: return "Toiletries"
        case .tech: return "Tech"
        case .health: return "Health & Recovery"
        case .crewEssentials: return "Crew Essentials"
        case .layoverExtras: return "Layover Extras"
        }
    }

    var sortOrder: Int {
        switch self {
        case .documents: return 0
        case .uniform: return 1
        case .footwear: return 2
        case .grooming: return 3
        case .toiletries: return 4
        case .tech: return 5
        case .health: return 6
        case .crewEssentials: return 7
        case .layoverExtras: return 8
        }
    }
}

struct PackingItem: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var category: PackingCategory
    var isChecked: Bool

    init(id: UUID = UUID(), title: String, category: PackingCategory, isChecked: Bool = false) {
        self.id = id
        self.title = title
        self.category = category
        self.isChecked = isChecked
    }
}
