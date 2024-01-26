import Foundation

class LearnViewModel: ObservableObject {
    struct ListItem {
        let title: String
        let description: String
        let url: URL
    }

    // Published property for the list items
    @Published var items: [ListItem] = [
        ListItem(title: "Title 1", description: "Description for item 1.", url: URL(string: "https://www.google.com")!),
        ListItem(title: "Title 2", description: "Description for item 2.", url: URL(string: "https://www.google.com")!),
        ListItem(title: "Title 3", description: "Description for item 3.", url: URL(string: "https://www.google.com")!)
    ]
    
    // Additional logic and functions related to 'LearnView' can be added here
}
