import Foundation

enum PackingRules {
    static func generateItems(config: TripConfig) -> [PackingItem] {
        var items: [PackingItem] = []

        func add(_ category: PackingCategory, _ title: String) {
            items.append(PackingItem(title: title, category: category))
        }

        func addRepeated(_ category: PackingCategory, _ title: String, count: Int) {
            guard count > 0 else { return }
            for i in 1...count {
                add(category, "\(title) (\(i))")
            }
        }

        let days = max(1, config.days)
        let layovers = max(0, config.layovers)

        // Documents
        add(.documents, "Passport + copies (offline)")
        add(.documents, "Crew ID (if applicable)")
        add(.documents, "Emergency contacts (offline)")
        add(.documents, "Visa docs (if applicable)")

        // Tech
        add(.tech, "Phone charger")
        add(.tech, "Backup cable")
        add(.tech, "Power bank")
        add(.tech, "Universal adapter")
        add(.tech, "Earbuds")

        // Toiletries base
        add(.toiletries, "Toothbrush + toothpaste")
        add(.toiletries, "Face wash (travel size)")
        add(.toiletries, "Moisturizer (travel size)")
        add(.toiletries, "Deodorant")
        add(.toiletries, "Wet wipes")
        add(.toiletries, "Hand sanitizer")

        // Crew essentials
        add(.crewEssentials, "Reusable water bottle")
        add(.crewEssentials, "Snack kit (bars/nuts)")
        add(.crewEssentials, "Notebook + pen")
        add(.crewEssentials, "Laundry bag")

        // Footwear
        add(.footwear, "Duty shoes")
        add(.footwear, "Blister patches")

        // Counts
        addRepeated(.uniform, "Underwear", count: days + 1)
        addRepeated(.uniform, "Socks", count: days + 1)

        let uniformSetsBase: Int = {
            if config.laundryAccess { return Int(ceil(Double(days) / 2.0)) }
            return min(days, 5)
        }()
        addRepeated(.uniform, "Uniform set", count: uniformSetsBase)

        if !config.laundryAccess && days > uniformSetsBase {
            add(.uniform, "Laundry plan reminder")
        }

        // Emirates-focused additions (best-practice style)
        if config.profile == .emirates {
            add(.uniform, "Lint roller")
            add(.uniform, "Stain remover pen")
            add(.uniform, "Mini sewing kit")
            add(.uniform, "Fabric freshener (travel size)")

            if config.spareUniformPieces {
                add(.uniform, "Spare uniform top")
                add(.uniform, "Spare hosiery/tights")
            }

            if config.groomingKitRequired {
                add(.grooming, "Hair pins")
                add(.grooming, "Hair ties")
                add(.grooming, "Comb/brush")
                add(.grooming, "Small hair gel/spray (carry-on friendly)")
                add(.grooming, "Nail file")
                add(.grooming, "Travel perfume atomizer")
                add(.grooming, "Breath mints")
            } else {
                add(.grooming, "Basic grooming essentials")
            }
        }

        // Duty type
        if config.dutyType == .longHaul {
            add(.health, "Compression socks")
            add(.health, "Eye mask")
            add(.health, "Earplugs")
            add(.health, "Hydration support (optional)")
            add(.crewEssentials, "Light travel pillow (optional)")
        }

        // Climate
        switch config.climate {
        case .cold:
            add(.layoverExtras, "Thermal layer")
            add(.layoverExtras, "Scarf")
            add(.layoverExtras, "Gloves")
            add(.toiletries, "Hand cream (travel size)")
        case .mild:
            add(.layoverExtras, "Light layer/jacket")
        case .hot:
            add(.toiletries, "Sunscreen (travel size)")
            add(.toiletries, "Anti-chafe (optional)")
            add(.layoverExtras, "Breathable casual outfit")
        }

        // Layovers
        if layovers >= 1 { add(.layoverExtras, "Casual outfit (layover)") }
        if layovers >= 2 { add(.layoverExtras, "Small day bag") }
        if layovers >= 3 { add(.layoverExtras, "Workout gear (optional)") }

        // Carry-on only
        if config.carryOnOnly {
            add(.toiletries, "Liquids under carry-on limit")
            add(.toiletries, "Mini containers (refillable)")
        } else {
            add(.crewEssentials, "Checked luggage tag + spare")
        }

        // Remove duplicates, keep order
        var seen = Set<String>()
        items = items.filter { item in
            let key = "\(item.category.rawValue)|\(item.title.lowercased())"
            if seen.contains(key) { return false }
            seen.insert(key)
            return true
        }

        // Sort by category order
        let orderMap = Dictionary(uniqueKeysWithValues: PackingCategory.allCases.map { ($0, $0.sortOrder) })
        items.sort { (orderMap[$0.category] ?? 999) < (orderMap[$1.category] ?? 999) }

        return items
    }
}
