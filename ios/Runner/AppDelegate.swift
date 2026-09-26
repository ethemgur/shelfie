import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "InstagramStoriesChannel") {
      InstagramStoriesChannel.register(with: registrar.messenger())
    }
  }
}

/// `share/instagram` platform channel: shares a rendered PNG to Instagram
/// Stories via the `instagram-stories://share` URL scheme and the pasteboard.
/// Kept in this file so it needs no Xcode project changes.
enum InstagramStoriesChannel {
  private static let pasteboardPrefix = "com.instagram.sharedSticker"

  static func register(with messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "share/instagram", binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "isAvailable":
        result(storiesURL(appId: "check").map { UIApplication.shared.canOpenURL($0) } ?? false)
      case "shareToStory":
        shareToStory(call.arguments as? [String: Any] ?? [:], result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private static func storiesURL(appId: String) -> URL? {
    var components = URLComponents(string: "instagram-stories://share")
    components?.queryItems = [URLQueryItem(name: "source_application", value: appId)]
    return components?.url
  }

  private static func shareToStory(_ args: [String: Any], result: @escaping FlutterResult) {
    guard let appId = args["appId"] as? String,
          let url = storiesURL(appId: appId),
          UIApplication.shared.canOpenURL(url)
    else {
      result(false)
      return
    }

    var item: [String: Any] = [:]
    if let path = args["backgroundPath"] as? String,
       let data = FileManager.default.contents(atPath: path) {
      item["\(pasteboardPrefix).backgroundImage"] = data
    }
    if let path = args["stickerPath"] as? String,
       let data = FileManager.default.contents(atPath: path) {
      item["\(pasteboardPrefix).stickerImage"] = data
    }
    guard !item.isEmpty else {
      result(false)
      return
    }
    if let top = args["topColor"] as? String {
      item["\(pasteboardPrefix).backgroundTopColor"] = top
    }
    if let bottom = args["bottomColor"] as? String {
      item["\(pasteboardPrefix).backgroundBottomColor"] = bottom
    }

    UIPasteboard.general.setItems(
      [item],
      options: [.expirationDate: Date().addingTimeInterval(5 * 60)]
    )
    UIApplication.shared.open(url, options: [:]) { opened in
      result(opened)
    }
  }
}
