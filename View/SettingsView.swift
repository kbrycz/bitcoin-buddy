import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()

    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top, 40)

            VStack(spacing: 20) {
                Toggle("30 Min Refresh Limit", isOn: $viewModel.toggleOne)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                    .foregroundColor(.white)
                Toggle("Price Fading Mode", isOn: $viewModel.toggleTwo)
                    .foregroundColor(.white)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                Toggle("Bitcoin Fee", isOn: $viewModel.toggleTwo)
                    .foregroundColor(.white)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                Toggle("Lightning Fee", isOn: $viewModel.toggleTwo)
                    .foregroundColor(.white)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .padding()

            Spacer()

            Text("Version 1.0.0")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
        }
        .background(Color.customBackground.edgesIgnoringSafeArea(.all)) // Set background color
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
