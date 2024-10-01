import Flutter
import SwiftUI
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.isNavigationBarHidden = true
        
        // Set the UINavigationController as the rootViewController
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        let swiftUIChannel = FlutterMethodChannel(name: "com.akshay",
                                                  binaryMessenger: controller.binaryMessenger)
        let videoChannel = FlutterMethodChannel(name: "video_player",
                                                  binaryMessenger: controller.binaryMessenger)
        swiftUIChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "loadUrl" {
                let arguments = call.arguments as? [String:Any]
                let myurl : String? = arguments?["url"] as? String
                let title : String? = arguments?["title"] as? String
                print(myurl ?? "")
                self.pushToNativeViewController(navigationController: navigationController,videoLink: myurl ?? "",videoTitle:title ?? "",channel: videoChannel)
                result(nil)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Function to push a new native UIViewController
    private func pushToNativeViewController(navigationController: UINavigationController,videoLink : String,videoTitle: String,channel: FlutterMethodChannel) {
        // Create an instance of the new UIViewController
        let webViewController = WebViewController()
        navigationController.isNavigationBarHidden = false
        webViewController.view.backgroundColor = .white
        webViewController.title = videoTitle
        webViewController.urlString = videoLink
        webViewController.flutterMethodChannel = channel
        
        
        // Push the native view controller onto the navigation stack
        navigationController.pushViewController(webViewController, animated: true)
    }
    
    @objc private func closeNativeScreen() {
        self.window.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
