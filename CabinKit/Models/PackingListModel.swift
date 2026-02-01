import Foundation

struct PackingListModel: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var createdAt: Date
    var config: TripConfig
    var items: [PackingItem]

    init(
        id: UUID = UUID(),
        name: String,
        createdAt: Date = Date(),
        config: TripConfig,
        items: [PackingItem]
    ) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.config = config
        self.items = items
    }
}
