import SwiftUI

struct TemplatesView: View {
    @EnvironmentObject private var vm: AppViewModel
    @State private var openedListId: UUID? = nil

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        vm.seedTemplatesIfNeeded()
                    } label: {
                        Label("Add starter templates", systemImage: "sparkles")
                    }
                }

                if vm.templates.isEmpty {
                    ContentUnavailableView("No templates", systemImage: "square.grid.2x2", description: Text("Save a trip as a template from a packing list."))
                } else {
                    Section("Templates") {
                        ForEach(vm.templates) { t in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(t.name).font(.headline)
                                Text(vm.subtitle(for: t)).font(.subheadline).foregroundStyle(.secondary)

                                HStack {
                                    Button("Use") {
                                        let list = vm.createAndSaveList(from: t)
                                        openedListId = list.id
                                    }
                                    .buttonStyle(.borderedProminent)

                                    Button("Load into New Trip") {
                                        vm.applyTemplateToDraft(t)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                        .onDelete(perform: vm.deleteTemplates)
                    }
                }
            }
            .navigationTitle("Templates")
            .toolbar { EditButton() }
            .navigationDestination(isPresented: Binding(
                get: { openedListId != nil },
                set: { if !$0 { openedListId = nil } }
            )) {
                if let id = openedListId {
                    PackingListView(listId: id)
                }
            }
        }
    }
}
