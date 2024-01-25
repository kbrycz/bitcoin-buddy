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
                    Label("Home", systemImage: "1.circle")
                }

            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "2.circle")
                }

            BullishView()
                .tabItem {
                    Label("Bull", systemImage: "3.circle")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "4.circle")
                }
        }
    }
}
