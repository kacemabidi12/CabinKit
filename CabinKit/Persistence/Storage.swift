import Foundation

final class Storage {
    private let listsKey = "savedPackingLists"
    private let templatesKey = "savedTemplates"

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        encoder.outputFormatting = [.prettyPrinted]
    }

    func saveLists(_ lists: [PackingListModel]) {
        do {
            let data = try encoder.encode(lists)
            UserDefaults.standard.set(data, forKey: listsKey)
        } catch {
            print("Save lists failed: \(error)")
        }
    }

    func loadLists() -> [PackingListModel] {
        guard let data = UserDefaults.standard.data(forKey: listsKey) else { return [] }
        do {
            return try decoder.decode([PackingListModel].self, from: data)
        } catch {
            print("Load lists failed: \(error)")
            return []
        }
    }

    func saveTemplates(_ templates: [PackingTemplate]) {
        do {
            let data = try encoder.encode(templates)
            UserDefaults.standard.set(data, forKey: templatesKey)
        } catch {
            print("Save templates failed: \(error)")
        }
    }

    func loadTemplates() -> [PackingTemplate] {
        guard let data = UserDefaults.standard.data(forKey: templatesKey) else { return [] }
        do {
            return try decoder.decode([PackingTemplate].self, from: data)
        } catch {
            print("Load templates failed: \(error)")
            return []
        }
    }
}
