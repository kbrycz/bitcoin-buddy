import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel // Your ViewModel

    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 60) // This creates a vertical spacer of 20 points in height
            VStack(spacing: 10) { // Adjust spacing as needed
                
                Text(viewModel.todaysDate)
                    .font(.system(size: 20, design: .rounded))
                    .minimumScaleFactor(0.1) // Allows the text to shrink
                    .foregroundColor(Color(hex: "#FFFFFF"))
                    .opacity(0.4)
                
                Spacer()
                
                HStack {
                    Text("$")
                        .font(.system(size: 30)) // Adjust size as needed
                        .foregroundColor(viewModel.priceColor)
                    Text(viewModel.bitcoinPrice)
                        .font(.system(size: 50, design: .rounded))
                        .minimumScaleFactor(0.1) // Allows the text to shrink
                        .foregroundColor(viewModel.priceColor)
                }
                .scaledToFit()
                
                HStack {
                    Text(viewModel.changeInPriceSignal)
                        .font(.system(size: 15)) // Adjust size as needed
                        .foregroundColor(viewModel.priceColor)
                    Text(viewModel.changeInPrice)
                        .font(.system(size: 20, design: .rounded))
                        .minimumScaleFactor(0.1) // Allows the text to shrink
                        .foregroundColor(viewModel.priceColor)
                }
                .scaledToFit()
                
                Spacer()
                    .frame(height: 40) // This creates a vertical spacer of 20 points in height
                
                // Custom Bordered Box View
                BorderedBoxView(title: "Today's Refreshes", value: viewModel.totalRefreshesToday)
                    .padding([.leading, .trailing])
            
                
                // Custom Bordered Box View
                BorderedBoxView(title: "All Time Refreshes", value: viewModel.totalRefreshesAllTime)
                    .padding([.leading, .trailing])
                
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
