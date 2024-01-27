import SwiftUI

@main
struct Bitcoin_BuddyApp: App {
    @State private var isShowingSplash = true
    // Preload MainTabView
    let mainView = MainTabView()

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Always present but will be covered by SplashScreenView initially
                mainView
                
                if isShowingSplash {
                    SplashScreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                isShowingSplash = false
                            }
                        }
                }
            }
        }
    }
}
