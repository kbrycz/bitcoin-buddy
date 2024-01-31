import SwiftUI

struct PriceView: View {
    @ObservedObject var viewModel: HomeViewModel // Your ViewModel

    var body: some View {
        
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
        
        if (viewModel.changeInPriceNumber != 0) {
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
        }
    }
}

struct PriceView_Previews: PreviewProvider {
    static var previews: some View {
        PriceView(viewModel: HomeViewModel())
    }
}
