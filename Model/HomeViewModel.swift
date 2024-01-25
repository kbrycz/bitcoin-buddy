import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var todaysDate: String = "April 5, 2020"
    @Published var bitcoinPrice: String = "50,000.00"
    @Published var prevBitcoinPrice: String = "50,000.00"
    @Published var changeInPrice: String = "100.00"
    @Published var changeInPriceSignal: String = "+"
    
    @Published var totalRefreshesToday: String = "10"
    @Published var totalRefreshesAllTime: String = "10,382"
    
    var priceColor: Color {
        guard let price = Double(bitcoinPrice.replacingOccurrences(of: ",", with: "")) else {
            return Color.white // Default color if the price is not a valid number
        }
        return price > 49000 ? Color.green : Color.red
    }

    func refreshData() {
        getBitcoinPrice()
        getTodaysDate()
    }
    
    func getBitcoinPrice() {
        // Simulating a change in the bitcoin price for demonstration
        // In a real scenario, you would fetch and update this value from a data source
        let newPrice = Double.random(in: 10000...200000)

        // Format the new price as a currency value
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "" // Remove the currency symbol if you don't want it
        formatter.maximumFractionDigits = 2 // Maximum number of decimal places

        if let formattedPrice = formatter.string(from: NSNumber(value: newPrice)) {
            bitcoinPrice = formattedPrice
        }
    }
    
    func getTodaysDate() {
        let currentDate = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy" // Format: April 5, 2020
        todaysDate = formatter.string(from: currentDate)
    }
}

