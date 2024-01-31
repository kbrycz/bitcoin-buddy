import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel // Your ViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel // Use environment object

    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 60) // This creates a vertical spacer of 20 points in height
            VStack(spacing: 10) { // Adjust spacing as needed
                
                PriceView(viewModel: viewModel)
                
                Spacer()
                    .frame(height: 40) // This creates a vertical spacer of 20 points in height

                DataView(viewModel: viewModel)
                
            }
            .padding() // Add padding around the VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(
            Image("bitcoin") // Background Bitcoin Image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .opacity(0.02) // Set transparency
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Center the image
        )
        .background(Color.customBackground.edgesIgnoringSafeArea(.all)) // Set background color
        .refreshable {
            viewModel.refreshData()
        }
        .onAppear {
            viewModel.loadEverything()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel(settingsViewModel: SettingsViewModel()))
            .environmentObject(SettingsViewModel()) // Provide SettingsViewModel as an environment object
    }
}
