import SwiftUI

struct TripSetupView: View {
    @EnvironmentObject private var vm: AppViewModel
    @State private var createdListId: UUID? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section("Airline profile") {
                    Picker("Profile", selection: $vm.draftConfig.profile) {
                        ForEach(AirlineProfile.allCases) { p in
                            Text(p.label).tag(p)
                        }
                    }
                }

                Section("Trip details") {
                    Stepper("Trip length: \(vm.draftConfig.days) days", value: $vm.draftConfig.days, in: 1...14)
                    Stepper("Layovers: \(vm.draftConfig.layovers)", value: $vm.draftConfig.layovers, in: 0...5)

                    Picker("Duty type", selection: $vm.draftConfig.dutyType) {
                        ForEach(DutyType.allCases) { t in
                            Text(t.label).tag(t)
                        }
                    }

                    Picker("Climate", selection: $vm.draftConfig.climate) {
                        ForEach(Climate.allCases) { c in
                            Text(c.label).tag(c)
                        }
                    }

                    Toggle("Laundry access", isOn: $vm.draftConfig.laundryAccess)
                    Toggle("Carry-on only", isOn: $vm.draftConfig.carryOnOnly)
                }

                if vm.draftConfig.profile == .emirates {
                    Section("Emirates-focused") {
                        Toggle("Grooming kit required", isOn: $vm.draftConfig.groomingKitRequired)
                        Toggle("Spare uniform pieces", isOn: $vm.draftConfig.spareUniformPieces)
                    }
                }

                Section {
                    Button {
                        let list = vm.createAndSaveListFromDraft()
                        createdListId = list.id
                    } label: {
                        Text("Generate packing list")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("CabinKit")
            .navigationDestination(isPresented: Binding(
                get: { createdListId != nil },
                set: { if !$0 { createdListId = nil } }
            )) {
                if let id = createdListId {
                    PackingListView(listId: id)
                }
            }
        }
    }
}
