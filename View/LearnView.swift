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
                
                Spacer()
                Spacer()
                VStack {
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
                        .cornerRadius(10)

                    }
                }
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))


                
                Spacer()
                
                Text("This some of the best bitcoin and macro economics material! Not financial advice! Do your own research!")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.white)
                    .lineSpacing(4)
                    .opacity(0.5)
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 5, trailing: 20))
                
                Spacer()
                Spacer()
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
