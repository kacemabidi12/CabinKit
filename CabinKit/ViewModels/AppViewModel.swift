import Foundation
import Combine
import SwiftUI

final class AppViewModel: ObservableObject {
    @Published var draftConfig: TripConfig = .default
    @Published var savedLists: [PackingListModel] = []
    @Published var templates: [PackingTemplate] = []

    private let storage = Storage()

    init() {
        savedLists = storage.loadLists()
        templates = storage.loadTemplates()
    }

    func bindingForList(id: UUID) -> BindingWrapper<PackingListModel>? {
        guard let idx = savedLists.firstIndex(where: { $0.id == id }) else { return nil }
        return BindingWrapper(
            get: { self.savedLists[idx] },
            set: { newValue in
                self.savedLists[idx] = newValue
                self.storage.saveLists(self.savedLists)
            }
        )
    }

    func createAndSaveListFromDraft() -> PackingListModel {
        let items = PackingRules.generateItems(config: draftConfig)
        let list = PackingListModel(name: defaultName(for: draftConfig), config: draftConfig, items: items)
        savedLists.insert(list, at: 0)
        storage.saveLists(savedLists)
        return list
    }

    func toggleItem(listId: UUID, itemId: UUID) {
        guard let li = savedLists.firstIndex(where: { $0.id == listId }),
              let ii = savedLists[li].items.firstIndex(where: { $0.id == itemId }) else { return }
        savedLists[li].items[ii].isChecked.toggle()
        storage.saveLists(savedLists)
    }

    func addItem(listId: UUID, title: String, category: PackingCategory) {
        guard let li = savedLists.firstIndex(where: { $0.id == listId }) else { return }
        savedLists[li].items.append(PackingItem(title: title, category: category))
        storage.saveLists(savedLists)
    }

    func deleteItem(listId: UUID, itemId: UUID) {
        guard let li = savedLists.firstIndex(where: { $0.id == listId }) else { return }
        savedLists[li].items.removeAll { $0.id == itemId }
        storage.saveLists(savedLists)
    }

    func deleteLists(at offsets: IndexSet) {
        savedLists.remove(atOffsets: offsets)
        storage.saveLists(savedLists)
    }

    func saveTemplate(fromListId listId: UUID, templateName: String) {
        guard let list = savedLists.first(where: { $0.id == listId }) else { return }
        templates.insert(PackingTemplate(name: templateName, baseConfig: list.config, baseItems: list.items), at: 0)
        storage.saveTemplates(templates)
    }

    func deleteTemplates(at offsets: IndexSet) {
        templates.remove(atOffsets: offsets)
        storage.saveTemplates(templates)
    }

    func applyTemplateToDraft(_ template: PackingTemplate) {
        draftConfig = template.baseConfig
    }

    func createAndSaveList(from template: PackingTemplate) -> PackingListModel {
        let list = PackingListModel(
            name: template.name,
            config: template.baseConfig,
            items: template.baseItems.map { PackingItem(title: $0.title, category: $0.category, isChecked: false) }
        )
        savedLists.insert(list, at: 0)
        storage.saveLists(savedLists)
        return list
    }

    func seedTemplatesIfNeeded() {
        guard templates.isEmpty else { return }

        var emirates = TripConfig.default
        emirates.profile = .emirates
        emirates.dutyType = .longHaul
        emirates.days = 5
        emirates.layovers = 2

        let t1 = PackingTemplate(name: "Emirates Long-haul", baseConfig: emirates, baseItems: PackingRules.generateItems(config: emirates))

        var short = TripConfig.default
        short.profile = .generic
        short.dutyType = .shortHaul
        short.days = 2
        short.layovers = 0

        let t2 = PackingTemplate(name: "Short-haul 2 days", baseConfig: short, baseItems: PackingRules.generateItems(config: short))

        templates = [t1, t2]
        storage.saveTemplates(templates)
    }

    func subtitle(for list: PackingListModel) -> String {
        "\(list.config.profile.label) • \(list.config.dutyType.label) • \(list.config.days)d • \(list.config.climate.label)"
    }

    func subtitle(for template: PackingTemplate) -> String {
        "\(template.baseConfig.profile.label) • \(template.baseConfig.dutyType.label) • \(template.baseConfig.days)d • \(template.baseConfig.climate.label)"
    }

    private func defaultName(for config: TripConfig) -> String {
        let p = config.profile == .emirates ? "Emirates" : "Trip"
        let d = config.dutyType == .longHaul ? "Long-haul" : "Short-haul"
        return "\(p) \(d) • \(config.days)d"
    }
}

/// Small helper to avoid SwiftUI type-check issues with Binding creation.
/// This is not SwiftUI.Binding, but enough for our views to read/write safely.
struct BindingWrapper<T> {
    let get: () -> T
    let set: (T) -> Void
    var value: T {
        get { get() }
        nonmutating set { set(newValue) }
    }
}
