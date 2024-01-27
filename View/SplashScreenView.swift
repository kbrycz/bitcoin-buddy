import SwiftUI

struct SplashScreenView: View {
    @State private var logoOpacity = 0.0

    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .scaleEffect(0.35) // Reduces the logo size to 50%
                .opacity(logoOpacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1)) {
                        logoOpacity = 1.0
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea(edges: .all) // Ensures the view covers the entire screen
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
