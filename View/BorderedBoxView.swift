import SwiftUI

struct BorderedBoxView: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .padding(.leading) // Add padding to the left side
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(Color(hex: "#FFFFFF"))
                .opacity(0.4)

            Spacer() // Pushes the content to the left and right edges

            Text(value)
                .padding(.trailing) // Add padding to the right side
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(Color(hex: "#FFFFFF"))
                .opacity(0.4)
        }
        .padding() // Padding inside the box
        .frame(maxWidth: .infinity) // Make the box as wide as the screen
        .background(
            RoundedRectangle(cornerRadius: 10) // Set the corner radius here
                .stroke(Color.init(red: 1, green: 1, blue: 1, opacity: 0.1), lineWidth: 1)
        )
    }
}
