import Foundation
import SwiftUI

struct MainTabView: View {
    // Create an instance of SettingsViewModel
    @StateObject var settingsViewModel = SettingsViewModel()

    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = Color.tabBackground // Convert SwiftUI Color to UIColor

        // Optional: Customize other tab bar properties if needed

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        TabView {
            HomeView(viewModel: HomeViewModel())
                .environmentObject(settingsViewModel) // Pass SettingsViewModel as environment object
                .tabItem {
                    Label("Home", systemImage: "house") // 'house' for home icon
                }

            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "graduationcap") // 'graduationcap' for learning/education icon
                }

            SettingsView()
                .environmentObject(settingsViewModel) // Pass SettingsViewModel as environment object
                .tabItem {
                    Label("Settings", systemImage: "gear") // 'gear' for settings/cog icon
                }
        }
    }
}
