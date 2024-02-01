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
        // Check if the UserDefaults contains a value for each toggle. If not, set them to true by default.
        if UserDefaults.standard.object(forKey: "toggleLastRefresh") == nil {
            toggleLastRefresh = true
        } else {
            toggleLastRefresh = UserDefaults.standard.bool(forKey: "toggleLastRefresh")
        }
        
        if UserDefaults.standard.object(forKey: "toggleMarketCap") == nil {
            toggleMarketCap = true
        } else {
            toggleMarketCap = UserDefaults.standard.bool(forKey: "toggleMarketCap")
        }
        
        if UserDefaults.standard.object(forKey: "toggleCirculatingSupply") == nil {
            toggleCirculatingSupply = true
        } else {
            toggleCirculatingSupply = UserDefaults.standard.bool(forKey: "toggleCirculatingSupply")
        }
        
        if UserDefaults.standard.object(forKey: "toggleBitcoinFees") == nil {
            toggleBitcoinFees = true
        } else {
            toggleBitcoinFees = UserDefaults.standard.bool(forKey: "toggleBitcoinFees")
        }
        
        if UserDefaults.standard.object(forKey: "toggleTodayRefreshes") == nil {
            toggleTodayRefreshes = true
        } else {
            toggleTodayRefreshes = UserDefaults.standard.bool(forKey: "toggleTodayRefreshes")
        }
        
        if UserDefaults.standard.object(forKey: "toggleAllTimeRefreshes") == nil {
            toggleAllTimeRefreshes = true
        } else {
            toggleAllTimeRefreshes = UserDefaults.standard.bool(forKey: "toggleAllTimeRefreshes")
        }
        
        // For toggle30Minutes, keep its current behavior, which respects the user's previous choice or defaults to false.
        toggle30Minutes = UserDefaults.standard.bool(forKey: "toggle30Minutes")
    }


}

