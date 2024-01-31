import SwiftUI

@main
struct Bitcoin_BuddyApp: App {
    @State private var isShowingSplash = true
    @State private var logoOpacity = 1.0 // Start with full opacity
    let mainView = MainTabView()

    var body: some Scene {
        WindowGroup {
            ZStack {
                mainView

                if isShowingSplash {
                    SplashScreenView(logoOpacity: $logoOpacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeInOut(duration: 1)) {
                                    logoOpacity = 0.0
                                    isShowingSplash = false
                                }
                            }
                        }
                }
            }
        }
    }
}
