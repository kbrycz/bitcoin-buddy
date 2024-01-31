import SwiftUI

struct LearnView: View {
    @ObservedObject var viewModel = LearnViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text("Learn")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                    .opacity(0.7)
                
                Text("Check out some of the best resources on macro economics and bitcoin!")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 5, trailing: 20))
                
                Spacer()
                
                ForEach(viewModel.items, id: \.title) { item in
                    HStack {
                        Image(item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width / 3, height: 80)
                            .padding(5)
                            .onTapGesture {
                                UIApplication.shared.open(item.url)
                            }

                        VStack(alignment: .leading) {
                            Text(item.title)
                                .font(.system(size: 14, design: .rounded))
                                .lineSpacing(4)
                                .foregroundColor(.white)
                                .opacity(0.7)
                                .onTapGesture {
                                    UIApplication.shared.open(item.url)
                                }
                        }

                        Spacer()
                    }
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
                    .background(Color.white.opacity(0.1))
                }
                Text("This is not financial advice! Do your own research!")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(0.5)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 5, trailing: 20))
            }
        }
        .background(Color.customBackground.edgesIgnoringSafeArea(.all))
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
}
