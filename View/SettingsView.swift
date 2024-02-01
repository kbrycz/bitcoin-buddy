import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: SettingsViewModel // Use environment object

    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top, 40)
                .opacity(0.7)

            VStack(spacing: 20) {
                Toggle("Last Refresh", isOn: $viewModel.toggleLastRefresh)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                    .foregroundColor(.white)
                    .opacity(0.7)
                Toggle("Market Cap", isOn: $viewModel.toggleMarketCap)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                    .foregroundColor(.white)
                    .opacity(0.7)
                Toggle("Circulating Supply", isOn: $viewModel.toggleCirculatingSupply)
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                Toggle("Bitcoin Fee", isOn: $viewModel.toggleBitcoinFees)
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                Toggle("Today's Refreshes", isOn: $viewModel.toggleTodayRefreshes)
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                Toggle("All Time Refreshes", isOn: $viewModel.toggleAllTimeRefreshes)
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                Toggle("30 Minute Lock", isOn: $viewModel.toggle30Minutes)
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .padding()

            Spacer()

            Text("Version 1.0.0")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            Text("Thank you to CoinMarketCap for price data")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
                .opacity(0.5)
        }
        .background(Color.customBackground.edgesIgnoringSafeArea(.all)) // Set background color
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsViewModel()) // Provide SettingsViewModel as an environment object
    }
}
