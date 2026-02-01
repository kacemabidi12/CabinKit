import Foundation

struct PackingTemplate: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var baseConfig: TripConfig
    var baseItems: [PackingItem]

    init(
        id: UUID = UUID(),
        name: String,
        baseConfig: TripConfig,
        baseItems: [PackingItem]
    ) {
        self.id = id
        self.name = name
        self.baseConfig = baseConfig
        self.baseItems = baseItems
    }
}
