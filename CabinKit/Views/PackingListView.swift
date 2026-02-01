import SwiftUI

struct PackingListView: View {
    @EnvironmentObject private var vm: AppViewModel
    let listId: UUID

    @State private var showAddItem = false
    @State private var showSaveTemplate = false
    @State private var templateName = ""

    var body: some View {
        Group {
            if let wrapper = vm.bindingForList(id: listId) {
                let list = wrapper.value
                content(list: list)
            } else {
                ContentUnavailableView("List not found", systemImage: "exclamationmark.triangle", description: Text("It may have been deleted."))
            }
        }
    }

    private func content(list: PackingListModel) -> some View {
        let categories = sortedCategories(items: list.items)

        return List {
            ForEach(categories, id: \.self) { cat in
                Section(cat.label) {
                    ForEach(list.items.filter { $0.category == cat }) { item in
                        Button {
                            vm.toggleItem(listId: list.id, itemId: item.id)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                Text(item.title)
                                Spacer()
                            }
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                vm.deleteItem(listId: list.id, itemId: item.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(list.name)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    templateName = list.name
                    showSaveTemplate = true
                } label: {
                    Image(systemName: "bookmark")
                }

                Button {
                    showAddItem = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddItem) {
            AddItemView { title, category in
                vm.addItem(listId: list.id, title: title, category: category)
            }
        }
        .sheet(isPresented: $showSaveTemplate) {
            SaveTemplateSheet(
                name: $templateName,
                onSave: {
                    vm.saveTemplate(fromListId: list.id, templateName: templateName)
                    showSaveTemplate = false
                },
                onCancel: { showSaveTemplate = false }
            )
        }
    }

    private func sortedCategories(items: [PackingItem]) -> [PackingCategory] {
        let set = Set(items.map { $0.category })
        return set.sorted { $0.sortOrder < $1.sortOrder }
    }
}

private struct SaveTemplateSheet: View {
    @Binding var name: String
    let onSave: () -> Void
    let onCancel: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Template name") {
                    TextField("e.g., Emirates Long-haul", text: $name)
                }
            }
            .navigationTitle("Save Template")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: onCancel)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save", action: onSave)
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
