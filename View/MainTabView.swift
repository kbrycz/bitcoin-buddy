import Foundation
import SwiftUI

struct MainTabView: View {
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = Color.tabBackground // Slightly darker color for the tab bar

        // Optional: Customize other tab bar properties if needed

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        TabView {
            HomeView(viewModel: HomeViewModel())
                .tabItem {
                    Label("Home", systemImage: "house") // 'house' for home icon
                }

            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "graduationcap") // 'graduationcap' for learning/education icon
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear") // 'gear' for settings/cog icon
                }
        }
    }
}
