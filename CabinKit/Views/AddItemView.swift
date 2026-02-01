import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var category: PackingCategory = .documents

    let onAdd: (String, PackingCategory) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Item") {
                    TextField("Item title", text: $title)
                }
                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(PackingCategory.allCases) { c in
                            Text(c.label).tag(c)
                        }
                    }
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        onAdd(trimmed, category)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
