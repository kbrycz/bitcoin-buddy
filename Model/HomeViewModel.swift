import SwiftUI
import Combine
import UIKit

class HomeViewModel: ObservableObject {
    private var settingsViewModel: SettingsViewModel
    
    @Published var todaysDate: String = ""
    @Published var bitcoinPrice: String = "0.00"
    @Published var percentChange24h: String = "0.00%"
    @Published var percentChange24hValue: Double = 0;
    @Published var circulatingSupply: String = ""
    @Published var marketCap: String = ""
    
    var bitcoinPriceNumber : Double = 0
    
    @Published var totalRefreshesToday: String = "0"
    @Published var totalRefreshesAllTime: String = "0"
    
    @Published var errorMessage: String? = nil
    @Published var helperMessage: String? = nil
    
    var lastRefreshTime: Date = Date()
    @Published var lastRefreshTimeAgo: String = "n/a"
    
    @Published var bitcoinTransactionFee: String = "0.00"
    
    @Published var refreshWaitMessage: String? = nil
    
    var timer: Timer?
    
    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        self.loadFromUserDefaults()
        self.startTimer()
        self.refreshData(true)
    }
    
    // Make sure to invalidate the timer when it is no longer needed
    deinit {
        timer?.invalidate()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateLastRefreshTimeAgo()
        }
    }
    
    var priceColor: Color {
        if self.percentChange24hValue == 0 {
            return Color.white
        }
        return percentChange24hValue > 0 ? Color.green : Color.red
    }
    
    func check30MinuteToggle() -> Bool {
        if settingsViewModel.toggle30Minutes {
            let timeSinceLastRefresh = Date().timeIntervalSince(lastRefreshTime)
            let remainingWaitTime = 1800 - timeSinceLastRefresh // 900 seconds = 15 minutes
            if remainingWaitTime > 0 {
                let minutes = Int(remainingWaitTime) / 60
                let seconds = Int(remainingWaitTime) % 60
                let minuteText = minutes == 1 ? "minute" : "minutes"
                let secondText = seconds == 1 ? "second" : "seconds"
                
                if minutes > 0 {
                    refreshWaitMessage = "Patience. You need to wait \(minutes) \(minuteText)."
                } else {
                    refreshWaitMessage = "Patience. You need to wait \(seconds) \(secondText)."
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.refreshWaitMessage = nil
                }
                return true
            }
        }
        return false
    }

    func refreshData(_ override : Bool) {
        // Check if it's allowed to refresh based on the 30-minute toggle
        if check30MinuteToggle() && !override {
            // If not allowed, exit the function early
            return
        }
        
        // Get the current date in "YYYY-MM-DD" format
        let currentDate = currentDateString()

        // Check if it's a new day
        if currentDate != UserDefaults.standard.string(forKey: UserDefaultsKeys.lastRefreshDate) {
            // It's a new day, so reset today's refresh count and update the last refresh date
            totalRefreshesToday = "0"
            UserDefaults.standard.set(currentDate, forKey: UserDefaultsKeys.lastRefreshDate)
        }

        // Proceed with the refreshing logic
        self.lastRefreshTime = Date() // Update the last refresh time
        updateLastRefreshTimeAgo() // Update the time ago based on the new last refresh time
        UserDefaults.standard.set(self.lastRefreshTime, forKey: UserDefaultsKeys.lastRefreshTime)

        UserDefaults.standard.set(currentDate, forKey: UserDefaultsKeys.lastRefreshDate)
        UserDefaults.standard.synchronize()
        
        // Trigger haptic feedback
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        feedbackGenerator.notificationOccurred(.success)

        print("Refreshing...")
        getTodaysDate()
        // Call getBitcoinPrice and then getBitcoinTransactionFee sequentially
        getBitcoinPrice(true) { [weak self] in
            self?.getBitcoinTransactionFee()
        }
        incrementRefreshCount()

        // Reset wait message after successful refresh
        refreshWaitMessage = nil
        
        UserDefaults.standard.set(totalRefreshesToday, forKey: UserDefaultsKeys.totalRefreshesToday)
        UserDefaults.standard.synchronize()
    }

    private func getAPIKey() -> String? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let apiKey = config["CoinMarketCapAPIKey"] as? String else {
            return nil
        }
        return apiKey
    }
        
    private func getBitcoinPrice(_ isRefresh: Bool, completion: @escaping () -> Void) {
        guard let apiKey = getAPIKey() else {
            print("API Key not found")
            return
        }

        let url = URL(string: "https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/latest?id=1")!
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error loading price: \(error.localizedDescription)"
                    return
                }
                guard let data = data else {
                    self.errorMessage = "Error loading price: Data is missing"
                    return
                }

                do {
                    let jsonResponse = try JSONDecoder().decode(CoinMarketCapResponse.self, from: data)
                    if let bitcoinData = jsonResponse.data["1"] {
                        let price = bitcoinData.quote.USD.price
                        let change24h = bitcoinData.quote.USD.percent_change_24h
                        let marketCap = bitcoinData.quote.USD.market_cap
                                                
                        self.bitcoinPriceNumber = price
                        self.percentChange24hValue = change24h
                        
                        // Check if the value is positive and prepend a "+" sign if true
                        if change24h > 0 {
                            self.percentChange24h = String(format: "+%.2f%%", change24h)
                        } else {
                            self.percentChange24h = String(format: "%.2f%%", change24h)
                        }
                        
                        self.circulatingSupply = self.formatNumberWithCommas(bitcoinData.circulating_supply)
                        self.bitcoinPrice = self.formatAsCurrency(price, true)
                        self.marketCap = self.formatMarketCap(marketCap)
                        
                        print("Successfully got bitcoin price: " + self.bitcoinPrice)
                        print("Successfully got bitcoin percent change: " + self.percentChange24h)
                        print("Successfully got bitcoin market cap: " + self.marketCap)
                        
                        completion()
                    }
                } catch {
                    self.errorMessage = "Error loading price: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func getBitcoinTransactionFee() {
        let url = URL(string: "https://bitcoiner.live/api/fees/estimates/latest?confidence=0.8")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                guard let data = data else {
                    print("Error: Data is missing")
                    return
                }

                do {
                    let response = try JSONDecoder().decode(BitcoinFeeResponse.self, from: data)
                    let estimates = response.estimates.values.map { $0.total }
                    let averageFeeSatoshi = self.calculateAverageTransactionFee(estimates)
                    let averageFeeUSD = self.convertSatoshiToUSD(averageFeeSatoshi)
                    if averageFeeUSD > 0.0 {
                        self.bitcoinTransactionFee = self.formatAsCurrency(averageFeeUSD, false)
                        print("Successfully got bitcoin transaction fee: " + self.bitcoinTransactionFee)
                    }
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    

    private func loadFromUserDefaults() {
        // Check if it's still today compared to the last saved refresh date
        let savedDate = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastRefreshDate) ?? ""
        let today = currentDateString()

        if savedDate == today {
            // Load today's refresh count if it's still the same day
            totalRefreshesToday = UserDefaults.standard.string(forKey: UserDefaultsKeys.totalRefreshesToday) ?? "0"
        } else {
            // It's a new day, reset today's refresh count
            totalRefreshesToday = "0"
            UserDefaults.standard.set(today, forKey: UserDefaultsKeys.lastRefreshDate)
        }

        totalRefreshesAllTime = UserDefaults.standard.string(forKey: UserDefaultsKeys.totalRefreshesAllTime) ?? "0"
        
        // Update lastRefreshTime from UserDefaults or set to now if not available
        let lastRefreshTimestamp = UserDefaults.standard.object(forKey: UserDefaultsKeys.lastRefreshTime) as? Date ?? Date()
        lastRefreshTime = lastRefreshTimestamp
        
        updateLastRefreshTimeAgo() // Ensure this method is called to update the time ago display
    }
    
    private func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    func incrementRefreshCount() {
        // Ensure this method updates UserDefaults with the current refresh time
        UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastRefreshTime)
        
        // Increment today's and all-time counts, then save
        let todayCount = (Int(totalRefreshesToday) ?? 0) + 1
        totalRefreshesToday = "\(todayCount)"
        UserDefaults.standard.set(totalRefreshesToday, forKey: UserDefaultsKeys.totalRefreshesToday)
        
        let allTimeCount = (Int(totalRefreshesAllTime.replacingOccurrences(of: ",", with: "")) ?? 0) + 1
        totalRefreshesAllTime = formattedCount(allTimeCount)
        UserDefaults.standard.set(totalRefreshesAllTime, forKey: UserDefaultsKeys.totalRefreshesAllTime)
    }


    private func formattedCount(_ count: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: count)) ?? "\(count)"
    }
    
    private func calculateAverageTransactionFee(_ fees: [TransactionTypeFees]) -> Double {
        let totalFees = fees.reduce(0.0) { sum, fee in
            let feeValues = [fee.p2pkh.satoshi, fee.p2shP2wpkh.satoshi, fee.p2wpkh.satoshi].filter { $0 > 0 }
            let averageFee = feeValues.isEmpty ? 0 : feeValues.reduce(0, +) / Double(feeValues.count)
            return sum + averageFee
        }
        return totalFees / Double(fees.count)
    }


    private func convertSatoshiToUSD(_ satoshi: Double) -> Double {
        // Assuming bitcoinPriceNumber is the price of 1 Bitcoin in USD
        let bitcoinPriceUSD = self.bitcoinPriceNumber
        let satoshiPerBitcoin = 100_000_000.0
        return (satoshi / satoshiPerBitcoin) * bitcoinPriceUSD
    }
    
    private func getTodaysDate() {
        let currentDate = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy" // Format: April 5, 2020
        todaysDate = formatter.string(from: currentDate)
    }
    
    private func updateLastRefreshTimeAgo() {
        let now = Date()
        let difference = Calendar.current.dateComponents([.minute, .hour, .day], from: lastRefreshTime, to: now)

        if let day = difference.day, day >= 30 {
            lastRefreshTimeAgo = "> 1 month ago"
        } else if let day = difference.day, day > 0 {
            lastRefreshTimeAgo = "\(day) day\(day > 1 ? "s" : "") ago"
        } else if let hour = difference.hour, hour > 0 {
            lastRefreshTimeAgo = "\(hour) hour\(hour > 1 ? "s" : "") ago"
        } else if let minute = difference.minute, minute > 0 {
            lastRefreshTimeAgo = "\(minute) minute\(minute > 1 ? "s" : "") ago"
        } else {
            lastRefreshTimeAgo = "< 1 minute ago"
        }
    }
    
    private func formatAsCurrency(_ number: Double, _ withoutSign: Bool) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US") // You can adjust the locale to your preference
        if (withoutSign) {
            formatter.currencySymbol = "" // Remove the currency symbol
        }
        formatter.maximumFractionDigits = 2 // Set the maximum number of decimal places

        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    private func formatNumberWithCommas(_ number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal // Use decimal style for adding commas
        numberFormatter.groupingSeparator = "," // Ensure the comma is used as the grouping separator
        return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    private func formatMarketCap(_ value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.maximumFractionDigits = 1 // Maximum one decimal place
        numberFormatter.minimumFractionDigits = 1 // Ensure at least one decimal place

        let currencySymbol = "$"
        
        let billion = 1_000_000_000.0
        let trillion = 1_000_000_000_000.0
        
        if value >= trillion {
            let formattedValue = value / trillion
            return "\(currencySymbol)\(numberFormatter.string(from: NSNumber(value: formattedValue)) ?? "")T"
        } else if value >= billion {
            let formattedValue = value / billion
            return "\(currencySymbol)\(numberFormatter.string(from: NSNumber(value: formattedValue)) ?? "")B"
        } else {
            // For values less than a billion, the formatter is already set to include at least one decimal
            return "\(currencySymbol)\(numberFormatter.string(from: NSNumber(value: value)) ?? "")"
        }
    }

    
    private struct BitcoinAPIResponse: Decodable {
        let last_trade_price: Double
        let price_24h: Double // Add this line
    }
    
    private struct UserDefaultsKeys {
        static let totalRefreshesToday = "totalRefreshesToday"
        static let totalRefreshesAllTime = "totalRefreshesAllTime"
        static let lastRefreshTime = "lastRefreshTime"
        static let lastRefreshDate = "lastRefreshDate" // Add this line
    }
    
    private struct BitcoinFeeResponse: Decodable {
        let estimates: [String: FeeEstimate]
    }

    private struct FeeEstimate: Decodable {
        let total: TransactionTypeFees
    }

    private struct TransactionTypeFees: Decodable {
        let p2pkh: Fee
        let p2shP2wpkh: Fee
        let p2wpkh: Fee

        enum CodingKeys: String, CodingKey {
            case p2pkh
            case p2shP2wpkh = "p2sh-p2wpkh"
            case p2wpkh
        }
    }


    private struct Fee: Decodable {
        let satoshi: Double
    }
    
    struct CoinMarketCapResponse: Decodable {
        let data: [String: Cryptocurrency]
    }

    struct Cryptocurrency: Decodable {
        let id: Int
        let name: String
        let symbol: String
        let circulating_supply: Double
        let quote: Quote
    }

    struct Quote: Decodable {
        let USD: USDQuote
    }

    struct USDQuote: Decodable {
        let price: Double
        let percent_change_24h: Double
        let market_cap: Double
    }

}

