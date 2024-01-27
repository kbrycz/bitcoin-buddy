import SwiftUI

struct LearnView: View {
    @ObservedObject var viewModel = LearnViewModel()

    var body: some View {
        List(viewModel.items, id: \.title) { item in
            HStack {
                Image(item.imageName) // Placeholder image
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 3)
                    .padding(.trailing, 8)
                    .onTapGesture {
                        UIApplication.shared.open(item.url)
                    }

                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(0.7)
                }

                Spacer()
            }
            .padding(10)
            .background(Color.white.opacity(0.1)) // Faded background for border effect
            .cornerRadius(10) // Rounded corners for the border
            .listRowBackground(Color.customBackground) // Set background for each row
        }
        .listStyle(PlainListStyle()) // Use PlainListStyle for full-width background
        .background(Color.customBackground.edgesIgnoringSafeArea(.all)) // Set background color
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}
