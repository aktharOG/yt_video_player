//
//  WebViewController.swift
//  Runner
//
//  Created by Akshay N on 05/09/24.
//

import UIKit
import WebKit
import Flutter

class WebViewController: UIViewController,WKScriptMessageHandler, WKNavigationDelegate {
    
    var urlString: String?
    
    var webView: WKWebView!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var flutterMethodChannel: FlutterMethodChannel?
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize WKWebView
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.configuration.allowsPictureInPictureMediaPlayback = false
        view.addSubview(webView)
        
        // Initialize and add activity indicator (circular progress)
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .orange  // Optional: Set color
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // Set up auto-layout constraints for webView
        // Set up auto-layout constraints for webView with 16:9 aspect ratio
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint for the width to match the safe area of the screen
        let widthConstraint = webView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor)
        
        // Constraint for the height to be 9/16 of the width (16:9 aspect ratio)
        let heightConstraint = webView.heightAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 9.0/16.0)
        
        // Center the webView horizontally and vertically
        let centerXConstraint = webView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let centerYConstraint = webView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        // Activate all constraints
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, centerXConstraint, centerYConstraint])
        
        // Set up auto-layout constraints for the activity indicator (centered)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        preventScreenRecordingAndScreenshot()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure urlString is not nil before trying to load it in the WebView
        webView.configuration.allowsPictureInPictureMediaPlayback = false
        webView.configuration.allowsAirPlayForMediaPlayback = false
        preventScreenRecordingAndScreenshot()
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
            activityIndicator.startAnimating()
        } else {
            print("Error: URL string is nil or invalid")
        }
    }
    
    // WKNavigationDelegate method: called when navigation starts
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Start the activity indicator when the webView starts loading
        activityIndicator.startAnimating()
        self.webView.isHidden = true
        
    }
    
    
    // Optional: WKNavigationDelegate method to handle events like page load completion
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Page Loaded")
        webView.evaluateJavaScript("""
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
    
    var myyoutube = document.getElementsByClassName("ytp-menuitem");
    for (var i = 0; i < myyoutube.length; i++) {
        myyoutube[4].style.display = 'none';
        myyoutube[5].style.display = 'none';
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
    video.addEventListener('loadeddata', function() {
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
    video.addEventListener('canplay', function() {
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
    video.addEventListener('pause', function() {
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
    video.addEventListener('timeupdate', function() {
                        var checkPos = setInterval(function() {
            var position = video.currentTime;
            window.webkit.messageHandlers.videoTimeUpdate.postMessage(position);
    },500);
        });
        video.addEventListener('webkitfullscreenchange', function() {
                var checkFullScreen = setInterval(function() {
                var isFullScreen = !!document.webkitFullscreenElement;
                window.webkit.messageHandlers.fullScreenStateChanged.postMessage(isFullScreen);
        },500);
            });
    """) { result, error in
            if let error = error {
                print("JavaScript injection failed: \(error)")
            } else {
                print("JavaScript injected successfully")
                
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+2,execute: {
            self.activityIndicator.stopAnimating()
            self.webView.isHidden = false
        })
    }
    
    // WKNavigationDelegate method: called when navigation fails
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Stop the activity indicator even if loading fails
        activityIndicator.stopAnimating()
        print("Error Loading Page: \(error.localizedDescription)")
        self.webView.isHidden = false
    }
    
    func preventScreenRecordingAndScreenshot() {
        NotificationCenter.default.addObserver(self, selector: #selector(screenCapturedDidChange), name: UIScreen.capturedDidChangeNotification, object: nil)
    }
    
    // Selector function for screen recording observation
    @objc func screenCapturedDidChange() {
        if UIScreen.main.isCaptured {
            // Take action if screen is being recorded (e.g., hide sensitive content)
            print("Screen is being recorded")
            webView.isHidden = true
            webView.closeAllMediaPresentations()
            let alert = UIAlertController(title: "Detection Alert", message: "Screen recording detected , please stop the recording and learn something", preferredStyle: .alert)
            self.navigationController?.present(alert, animated: true)
            // Hide the web view content
        } else {
            // Restore the web view when recording stops
            webView.isHidden = false
            self.navigationController?.dismiss(animated: true)
        }
    }
    
    // WKScriptMessageHandler function to handle the message from JavaScript
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "videoTimeUpdate", let position = message.body as? Double {
            // Call Flutter method with the video position
            print("ddddddddd------> \(position)")
            flutterMethodChannel?.invokeMethod("updatePosition", arguments: position)
        }
    }
}

