import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var todaysDate: String = ""

    @Published var bitcoinPrice: String = "0.00"
    @Published var prevBitcoinPrice: String = "0.00"
    @Published var changeInPrice: String = "0"
    @Published var changeInPriceSignal: String = "+"
    
    var bitcoinPriceNumber : Int = 0
    var prevBitcoinPriceNumber : Int = 0
    var changeInPriceNumber : Int = 0
    
    @Published var totalRefreshesToday: String = "10"
    @Published var totalRefreshesAllTime: String = "10,382"
    @Published var lastRefreshTimeAgo: String = "1 Min ago"
    
    @Published var errorMessage: String? = nil
    
    var lastRefreshTime: Date = Date()
    
    
    var priceColor: Color {
        if changeInPriceNumber == 0 {
            return Color.white
        }
        return changeInPriceNumber > 0 ? Color.green : Color.red
    }
    
    func loadEverything() {
        getTodaysDate()
        getBitcoinPrice(false)
    }

    func refreshData() {
        getTodaysDate()
        getBitcoinPrice(true)
    }

    
    func getBitcoinPrice(_ isRefresh: Bool) {
        let url = URL(string: "https://api.blockchain.com/v3/exchange/tickers/BTC-USD")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                guard let data = data else {
                    self.errorMessage = "Error: Data is missing"
                    return
                }

                do {
                    let json = try JSONDecoder().decode(BitcoinAPIResponse.self, from: data)
                    let newPrice = json.last_trade_price
                    
                    if isRefresh && self.bitcoinPriceNumber > 0 {
                        self.prevBitcoinPrice = self.bitcoinPrice
                        self.prevBitcoinPriceNumber = self.bitcoinPriceNumber
                    }

                    self.bitcoinPrice = String(format: "%.2f", newPrice)
                    self.bitcoinPriceNumber = Int(newPrice)
                    
                    // Update bitcoinPrice with formatted string
                   let formattedPrice = self.formatAsCurrency(newPrice)
                   self.bitcoinPrice = formattedPrice

                    // Calculate change in price
                    if isRefresh {
                        self.changeInPriceNumber = self.bitcoinPriceNumber - self.prevBitcoinPriceNumber
                        self.changeInPrice = String(self.changeInPriceNumber)
                        self.changeInPriceSignal = self.changeInPriceNumber >= 0 ? "+" : "-"
                    }
                    
                    self.errorMessage = nil
                } catch {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    
    func getTodaysDate() {
        let currentDate = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy" // Format: April 5, 2020
        todaysDate = formatter.string(from: currentDate)
    }
    
    private func formatAsCurrency(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US") // You can adjust the locale to your preference
        formatter.currencySymbol = "" // Remove the currency symbol
        formatter.maximumFractionDigits = 2 // Set the maximum number of decimal places

        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    
    struct BitcoinAPIResponse: Decodable {
        let last_trade_price: Double
    }
}

