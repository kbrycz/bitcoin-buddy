import SwiftUI
import Combine


class HomeViewModel: ObservableObject {
    @Published var todaysDate: String = ""

    @Published var bitcoinPrice: String = "0.00"
    @Published var changeInPrice: String = "0"
    @Published var changeInPriceSignal: String = "+"
    
    var bitcoinPriceNumber : Int = 0
    var prevBitcoinPriceNumber : Int = 0
    var changeInPriceNumber : Double = 0
    
    @Published var totalRefreshesToday: String = "0"
    @Published var totalRefreshesAllTime: String = "0"
    
    @Published var errorMessage: String? = nil
    @Published var helperMessage: String? = nil
    
    var lastRefreshTime: Date = Date()
    @Published var lastRefreshTimeAgo: String = "n/a"
    
    @Published var bitcoinTransactionFee: String = "0.00"
    
    var timer: Timer?
    
    init() {
        print("Initializing for first time")
        self.lastRefreshTime = Date()
        loadFromUserDefaults()
        updateLastRefreshTimeAgo()
        startTimer()
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
        if changeInPriceNumber == 0 {
            return Color.white
        }
        return changeInPriceNumber > 0 ? Color.green : Color.red
    }
    
    func loadEverything() {
        getTodaysDate()
        getBitcoinPrice(false)
        getBitcoinTransactionFee()
    }

    func refreshData() {
        print("Refreshing...")
        getTodaysDate()
        getBitcoinPrice(true)
        incrementRefreshCount()
        updateLastRefreshTimeAgo()
        getBitcoinTransactionFee()
        self.lastRefreshTime = Date()
    }
        
    private func getBitcoinPrice(_ isRefresh: Bool) {
        let url = URL(string: "https://api.blockchain.com/v3/exchange/tickers/BTC-USD")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = "Error loading price"
                    return
                }
                guard let data = data else {
                    print("Error: Data is missing")
                    self.errorMessage = "Error loading price"
                    return
                }

                do {
                    let json = try JSONDecoder().decode(BitcoinAPIResponse.self, from: data)
                    let newPrice = json.last_trade_price
                                        
                    let price24h = json.price_24h
                    self.prevBitcoinPriceNumber = Int(price24h)

                    self.bitcoinPrice = String(format: "%.2f", newPrice)
                    self.bitcoinPriceNumber = Int(newPrice)
                    
                    // Update bitcoinPrice with formatted string
                   let formattedPrice = self.formatAsCurrency(newPrice, true)
                   self.bitcoinPrice = formattedPrice

                    self.changeInPriceNumber = Double(self.bitcoinPriceNumber) - Double(self.prevBitcoinPriceNumber)
                    self.changeInPrice = self.formatAsCurrency(self.changeInPriceNumber, false)
                    self.changeInPriceSignal = self.changeInPriceNumber >= 0 ? "+" : "-"
                    print("Updating bitcoin change in price: " + self.changeInPriceSignal + String(self.changeInPrice))
                    
                    self.errorMessage = nil
                } catch {
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = "Error loading price"
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
                    self.bitcoinTransactionFee = self.formatAsCurrency(averageFeeUSD, false)
                    print("Successfully got bitcoin transaction fee: " + self.bitcoinTransactionFee)
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    
    private func loadFromUserDefaults() {
        // Load total refreshes today
        if let totalToday = UserDefaults.standard.string(forKey: UserDefaultsKeys.totalRefreshesToday) {
            totalRefreshesToday = totalToday
        }

        // Load total refreshes all time
        if let totalAllTime = UserDefaults.standard.string(forKey: UserDefaultsKeys.totalRefreshesAllTime) {
            totalRefreshesAllTime = totalAllTime
        }

        // Load last refresh time
        if let lastRefreshString = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastRefreshTime),
           let lastTime = DateFormatter().date(from: lastRefreshString) {
            lastRefreshTime = lastTime
        } else {
            lastRefreshTime = Date()
        }
    }
    
    private func incrementRefreshCount() {
        // Increment today's refresh count
        let todayCount = (Int(totalRefreshesToday) ?? 0) + 1
        totalRefreshesToday = "\(todayCount)"
        UserDefaults.standard.set(totalRefreshesToday, forKey: UserDefaultsKeys.totalRefreshesToday)

        // Increment all-time refresh count
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
        let bitcoinPriceUSD = Double(bitcoinPriceNumber)
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

    
    private struct BitcoinAPIResponse: Decodable {
        let last_trade_price: Double
        let price_24h: Double // Add this line
    }
    
    private struct UserDefaultsKeys {
        static let totalRefreshesToday = "totalRefreshesToday"
        static let totalRefreshesAllTime = "totalRefreshesAllTime"
        static let lastRefreshTime = "lastRefreshTime"
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


}

