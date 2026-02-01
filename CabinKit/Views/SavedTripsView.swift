import SwiftUI

struct SavedTripsView: View {
    @EnvironmentObject private var vm: AppViewModel

    var body: some View {
        NavigationStack {
            List {
                if vm.savedLists.isEmpty {
                    ContentUnavailableView("No saved trips", systemImage: "tray", description: Text("Create a trip to generate your first packing list."))
                } else {
                    ForEach(vm.savedLists) { list in
                        NavigationLink {
                            PackingListView(listId: list.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(list.name).font(.headline)
                                Text(vm.subtitle(for: list)).font(.subheadline).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: vm.deleteLists)
                }
            }
            .navigationTitle("Saved Trips")
            .toolbar { EditButton() }
        }
    }
}
