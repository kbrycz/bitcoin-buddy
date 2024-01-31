import SwiftUI

struct DataView: View {
    @ObservedObject var viewModel: HomeViewModel // Your ViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel // Use environment object

    var body: some View {
        
        if settingsViewModel.toggleLastRefresh {
            BorderedBoxView(title: "Last Refresh", value: viewModel.lastRefreshTimeAgo)
                .padding([.leading, .trailing])
        }
        
        if settingsViewModel.toggleTodayRefreshes {
            BorderedBoxView(title: "Today's Refreshes", value: viewModel.totalRefreshesToday)
                .padding([.leading, .trailing])
        }
        
        if settingsViewModel.toggleAllTimeRefreshes {
            BorderedBoxView(title: "All Time Refreshes", value: viewModel.totalRefreshesAllTime)
                .padding([.leading, .trailing])
        }

        if (settingsViewModel.toggleBitcoinFees && viewModel.bitcoinTransactionFee != "") {
            BorderedBoxView(title: "Avg Transaction Fee", value: viewModel.bitcoinTransactionFee)
                .padding([.leading, .trailing])
        }

        if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .font(.system(size: 15, design: .rounded))
                .padding()
        }
        
        if viewModel.refreshWaitMessage != nil {
            Text(viewModel.refreshWaitMessage!)
                .foregroundColor(.white)
                .opacity(0.5)
                .padding()
                .font(.system(size: 15, design: .rounded))
                
        }
    
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView(viewModel: HomeViewModel(settingsViewModel: SettingsViewModel()))
            .environmentObject(SettingsViewModel()) // Provide SettingsViewModel as an environment object
    }
}
