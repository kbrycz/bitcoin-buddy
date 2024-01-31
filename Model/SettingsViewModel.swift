import Foundation

class SettingsViewModel: ObservableObject {
    
    @Published var toggleLastRefresh: Bool = UserDefaults.standard.bool(forKey: "toggleLastRefresh") {
        didSet {
            UserDefaults.standard.set(toggleLastRefresh, forKey: "toggleLastRefresh")
        }
    }
    
    @Published var toggleMarketCap: Bool = UserDefaults.standard.bool(forKey: "toggleMarketCap") {
        didSet {
            UserDefaults.standard.set(toggleMarketCap, forKey: "toggleMarketCap")
        }
    }
    
    @Published var toggleCirculatingSupply: Bool = UserDefaults.standard.bool(forKey: "toggleCirculatingSupply") {
        didSet {
            UserDefaults.standard.set(toggleCirculatingSupply, forKey: "toggleCirculatingSupply")
        }
    }
    
    @Published var toggleBitcoinFees: Bool = UserDefaults.standard.bool(forKey: "toggleBitcoinFees") {
        didSet {
            UserDefaults.standard.set(toggleBitcoinFees, forKey: "toggleBitcoinFees")
        }
    }
    
    @Published var toggleTodayRefreshes: Bool = UserDefaults.standard.bool(forKey: "toggleTodayRefreshes") {
        didSet {
            UserDefaults.standard.set(toggleTodayRefreshes, forKey: "toggleTodayRefreshes")
        }
    }

    @Published var toggleAllTimeRefreshes: Bool = UserDefaults.standard.bool(forKey: "toggleAllTimeRefreshes") {
        didSet {
            UserDefaults.standard.set(toggleAllTimeRefreshes, forKey: "toggleAllTimeRefreshes")
        }
    }
    
    @Published var toggle30Minutes: Bool = UserDefaults.standard.bool(forKey: "toggle30Minutes") {
        didSet {
            UserDefaults.standard.set(toggle30Minutes, forKey: "toggle30Minutes")
        }
    }
    


    // Initialize with saved values
    init() {
        toggleLastRefresh = UserDefaults.standard.bool(forKey: "toggleLastRefresh")
        toggleMarketCap = UserDefaults.standard.bool(forKey: "toggleMarketCap")
        toggleCirculatingSupply = UserDefaults.standard.bool(forKey: "toggleCirculatingSupply")
        toggleBitcoinFees = UserDefaults.standard.bool(forKey: "toggleBitcoinFees")
        toggleTodayRefreshes = UserDefaults.standard.bool(forKey: "toggleTodayRefreshes")
        toggleAllTimeRefreshes = UserDefaults.standard.bool(forKey: "toggleAllTimeRefreshes")
        toggle30Minutes = UserDefaults.standard.bool(forKey: "toggle30Minutes")

    }

}

