import SwiftUI
import WebKit

struct BullishView: View {
    // Replace with the URL of the Medium article you want to display
    let mediumArticleURL = URL(string:"https://medium.com/@karlrbrycz/bitcoin-the-financial-revolution-we-need-now-more-than-ever-70dddba4081d")!

    var body: some View {
        WebView(url: mediumArticleURL)
            .edgesIgnoringSafeArea(.all) // Use edgesIgnoringSafeArea if needed
    }
}

struct BullishViewView_Previews: PreviewProvider {
    static var previews: some View {
        BullishView()
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
