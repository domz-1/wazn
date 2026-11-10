import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let nativeChannel = FlutterMethodChannel(name: "com.wazn.app/native", binaryMessenger: controller.binaryMessenger)

    nativeChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "launchApp" {
        guard let args = call.arguments as? [String: Any],
              let pkg = args["package"] as? String else {
          result(false)
          return
        }

        let schemeMap: [String: String] = [
          "tiktok": "snssdk1233://",
          "com.zhiliaoapp.musically": "snssdk1233://",
          "facebook": "fb://",
          "com.facebook.katana": "fb://",
          "instagram": "instagram://",
          "com.instagram.android": "instagram://",
          "youtube": "youtube://",
          "com.google.android.youtube": "youtube://",
          "snapchat": "snapchat://",
          "com.snapchat.android": "snapchat://",
          "twitter": "twitter://",
          "x": "twitter://",
          "com.twitter.android": "twitter://",
          "whatsapp": "whatsapp://",
          "com.whatsapp": "whatsapp://",
          "telegram": "tg://",
          "org.telegram.messenger": "tg://"
        ]

        let urlString = schemeMap[pkg.lowercased()] ?? (pkg.contains("://") ? pkg : "\(pkg)://")
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:]) { success in
            result(success)
          }
        } else {
          result(false)
        }
      } else if call.method == "getInstalledApps" {
        result([])
      } else if call.method == "hasUsagePermission" {
        result(true)
      } else if call.method == "hasOverlayPermission" {
        result(true)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
