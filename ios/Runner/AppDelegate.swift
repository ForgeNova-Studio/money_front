import Flutter
import UIKit
import NidThirdPartyLogin

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var initialDeepLink: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // 딥링크로 앱이 시작된 경우 초기 URL 저장
    if let url = launchOptions?[.url] as? URL, url.scheme == "moamoa" {
      initialDeepLink = url.absoluteString
    }

    // MethodChannel 설정 (Flutter에서 getInitialLink 호출 처리)
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "moamoa/deeplink", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler { [weak self] (call, result) in
      if call.method == "getInitialLink" {
        result(self?.initialDeepLink)
        self?.initialDeepLink = nil
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // URL Scheme 콜백 처리 (네이버 로그인 + moamoa:// 딥링크)
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    // NidOAuth를 통한 네이버 로그인 콜백 처리
    if (NidOAuth.shared.handleURL(url) == true) {
      return true
    }

    // moamoa:// 딥링크 처리 → Flutter MethodChannel로 전달
    if url.scheme == "moamoa" {
      let controller = window?.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "moamoa/deeplink", binaryMessenger: controller.binaryMessenger)
      channel.invokeMethod("onDeepLink", arguments: url.absoluteString)
      return true
    }

    return super.application(app, open: url, options: options)
  }
}
