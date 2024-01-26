import Foundation

class SettingsViewModel: ObservableObject {
    // Published properties for the toggle states
    @Published var toggleOne: Bool = false
    @Published var toggleTwo: Bool = false

    // Additional logic related to Settings can be added here
}
