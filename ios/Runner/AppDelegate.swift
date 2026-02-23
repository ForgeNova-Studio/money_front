import Flutter
import UIKit
import NidThirdPartyLogin

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private static let deepLinkChannelName = "moamoa/deeplink"
  private static var deepLinkChannel: FlutterMethodChannel?
  private static var initialDeepLink: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 앱 시작 시 URL launch option이 있을 경우 초기 딥링크로 보관
    if let url = launchOptions?[.url] as? URL, url.scheme == "moamoa" {
      _ = Self.handleIncomingURL(url, shouldNotifyFlutter: false)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: Self.deepLinkChannelName,
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )

    channel.setMethodCallHandler { call, result in
      if call.method == "getInitialLink" {
        result(Self.consumeInitialDeepLink())
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    Self.deepLinkChannel = channel
  }

  // URL Scheme 콜백 처리 (네이버 로그인 + moamoa:// 딥링크)
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    // UIScene 전환 후에는 SceneDelegate에서 처리되지만,
    // 호환성을 위해 AppDelegate 경로도 유지한다.
    if Self.handleIncomingURL(url, shouldNotifyFlutter: true) {
      return true
    }

    return super.application(app, open: url, options: options)
  }

  @discardableResult
  static func handleIncomingURL(_ url: URL, shouldNotifyFlutter: Bool) -> Bool {
    // NidOAuth를 통한 네이버 로그인 콜백 처리
    if NidOAuth.shared.handleURL(url) {
      return true
    }

    // moamoa:// 딥링크 처리
    if url.scheme == "moamoa" {
      initialDeepLink = url.absoluteString
      if shouldNotifyFlutter {
        deepLinkChannel?.invokeMethod("onDeepLink", arguments: url.absoluteString)
      }
      return true
    }

    return false
  }

  private static func consumeInitialDeepLink() -> String? {
    let value = initialDeepLink
    initialDeepLink = nil
    return value
  }
}
