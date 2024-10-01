//
//  YouTubeWebView.swift
//  Runner
//
//  Created by Akshay N on 02/09/24.
//

import SwiftUI
import WebKit

struct YouTubeWebView: View {
    let videoURL: URL
    @State private var isShowingWebView = true
    var body: some View {
        ZStack {
            if isShowingWebView {
            ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .orange))
            .scaleEffect(2)
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isShowingWebView = false
                }
            }
            }
            
            if !isShowingWebView {
            WebView(url: videoURL, jsCode: jsCode)
                .aspectRatio(16/9, contentMode: .fit)
            }
        }
    }
    
    
    var jsCode:String = """
    var myyoutubelogo = document.getElementsByClassName("ytp-large-play-button ytp-button ytp-large-play-button-red-bg");
    for (var i = 0; i < myyoutubelogo.length; i++) {
        myyoutubelogo[i].style.display = 'none';
    }
    
    var myyoutube = document.getElementsByClassName("ytp-youtube-button ytp-button yt-uix-sessionlink");
    for (var i = 0; i < myyoutube.length; i++) {
        myyoutube[i].style.display = 'none';
    }
    
    var title = document.getElementsByClassName("ytp-chrome-top ytp-show-cards-title");
    for (var i = 0; i < title.length; i++) {
        title[i].style.display = 'none';
    }
    
    var endscreen = document.getElementsByClassName("html5-endscreen ytp-player-content videowall-endscreen ytp-endscreen-paginate ytp-show-tiles");
    for (var i = 0; i < endscreen.length; i++) {
        endscreen[i].style.display = 'none';
    }
    
    var logo = document.getElementsByClassName("annotation annotation-type-custom iv-branding");
    for (var i = 0; i < logo.length; i++) {
        logo[i].style.display = 'none';
    }
    
    var video = document.querySelector('video');
    
    video.addEventListener('play', function() {
        var checkElements = setInterval(function() {
            var myyoutube = document.getElementsByClassName("ytp-menuitem");
                    for (var i = 0; i < myyoutube.length; i++) {
                        myyoutube[4].style.display = 'none';
                        myyoutube[5].style.display = 'none';
                    }
    
            var sub = document.getElementsByClassName("branding-img-container ytp-button");
            for (var i = 0; i < sub.length; i++) {
                sub[i].style.display = 'none';
            }
        }, 500);
    
        var checkRelatedVideos = setInterval(function() {
            var relatedVideos = document.getElementsByClassName("ytp-endscreen-content");
    
            if (relatedVideos.length > 0) {
                for (var i = 0; i < relatedVideos.length; i++) {
                    relatedVideos[i].style.display = 'none';
                }
                clearInterval(checkRelatedVideos);
            }
        }, 500);
    
        var checkButtons = setInterval(function() {
            var previousButton = document.getElementsByClassName("ytp-button ytp-endscreen-previous");
    
            if (previousButton.length > 0) {
                for (var i = 0; i < previousButton.length; i++) {
                    previousButton[i].style.display = 'none';
                }
                clearInterval(checkButtons);
            }
    
            var nextButton = document.getElementsByClassName("ytp-button ytp-endscreen-next");
    
            if (nextButton.length > 0) {
                for (var i = 0; i < nextButton.length; i++) {
                    nextButton[i].style.display = 'none';
                }
                clearInterval(checkButtons);
            }
        }, 500);
    });
    """
}


struct WebView: UIViewRepresentable {
    let url: URL
    let jsCode: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript(parent.jsCode) { result, error in
                if let error = error {
                    print("JavaScript injection failed: \(error)")
                } else {
                    print("JavaScript injected successfully")
                    
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("do ---didFail")
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("do ---didFailProvisionalNavigation")
        }
    }
}

//#Preview {
//    YouTubeWebView(
//        videoURL: URL(string: "https://www.youtube.com/embed/A3s07JYA48o")!,
//        videoTitle: "Sample title",
//        videoDescription: "Hello description"
//    )
//}


extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
