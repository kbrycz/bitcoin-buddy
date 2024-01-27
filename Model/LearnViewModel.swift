import Foundation
import SwiftUI

class LearnViewModel: ObservableObject {
    struct ListItem {
        let imageName: String
        let title: String
        let url: URL
    }

    // Published property for the list items
    @Published var items: [ListItem] = [
        ListItem(imageName: "bitcoin1", title: "How The Economic Machine Works by Ray Dalio", url: URL(string: "https://www.youtube.com/watch?v=PHe0bXAIuk0&list=PLVc8YTaYzbIuIxwHotQ7U3mSSD669XRt9&index=1")!),
        ListItem(imageName: "bitcoin8", title: "Principles for Dealing with the Changing World Order by Ray Dalio", url: URL(string: "https://www.youtube.com/watch?v=xguam0TKMw8")!),
        ListItem(imageName: "bitcoin6", title: "Bitcoin For Beginners", url: URL(string: "https://www.youtube.com/watch?v=IQHLpdWvyK4&t=852s")!),
        ListItem(imageName: "bitcoin2", title: "Saifedean Ammous: Bitcoin, Anarchy, and Austrian Economics", url: URL(string: "https://www.youtube.com/watch?v=gp4U5aH_T6A&list=PLVc8YTaYzbIuIxwHotQ7U3mSSD669XRt9&index=17")!),
        ListItem(imageName: "bitcoin3", title: "The Immaculate Conception: Bitcoin vs Fiat Standard", url: URL(string: "https://www.youtube.com/watch?v=FXvQcuIb5rU&list=PLVc8YTaYzbIuIxwHotQ7U3mSSD669XRt9&index=12")!),
        ListItem(imageName: "bitcoin5", title: "Alex Gladstein: Bitcoin, Authoritarianism, and Human Rights", url: URL(string: "https://www.youtube.com/watch?v=kSbMU5CbFM0&t=3s")!),
        ListItem(imageName: "bitcoin4", title: "The Real Reason To Buy Bitcoin in 15 minutes with Dylan LeClair", url: URL(string: "https://www.youtube.com/watch?v=uBMUGChTp4w&list=PLVc8YTaYzbIuIxwHotQ7U3mSSD669XRt9&index=21")!),
        ListItem(imageName: "bitcoin9", title: "Can Bitcoin Free North Koreans?", url: URL(string: "https://www.youtube.com/watch?v=J1qj2ED6BPw&list=PLVc8YTaYzbIuIxwHotQ7U3mSSD669XRt9&index=15")!),
        ListItem(imageName: "bitcoin7", title: "Why The Ethereum Merge is a Monumental Blunder", url: URL(string: "https://www.youtube.com/watch?v=gyP0uxxB6V8&list=PLVc8YTaYzbIuIxwHotQ7U3mSSD669XRt9&index=20")!)

    ]
    
    // Additional logic and functions related to 'LearnView' can be added here
}
