import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    for urlContext in connectionOptions.urlContexts {
      _ = AppDelegate.handleIncomingURL(urlContext.url, shouldNotifyFlutter: false)
    }
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    super.scene(scene, openURLContexts: URLContexts)

    for urlContext in URLContexts {
      _ = AppDelegate.handleIncomingURL(urlContext.url, shouldNotifyFlutter: true)
    }
  }
}
