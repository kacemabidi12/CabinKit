import SwiftUI

struct RootView: View {
    @StateObject private var vm = AppViewModel()

    var body: some View {
        TabView {
            TripSetupView()
                .tabItem { Label("New Trip", systemImage: "plus.circle") }

            SavedTripsView()
                .tabItem { Label("Saved", systemImage: "tray.full") }

            TemplatesView()
                .tabItem { Label("Templates", systemImage: "square.grid.2x2") }
        }
        .environmentObject(vm)
    }
}
