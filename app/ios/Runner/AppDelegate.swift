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
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "DeviceInfoPlugin") {
      DeviceInfoPlugin.register(with: registrar)
    }
  }
}

private final class DeviceInfoPlugin: NSObject, FlutterPlugin {
  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "swingmate/device_info", binaryMessenger: registrar.messenger())
    let instance = DeviceInfoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "getDeviceInfo" else {
      result(FlutterMethodNotImplemented)
      return
    }
    let device = UIDevice.current
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let defaults = UserDefaults.standard
    let deviceId = defaults.string(forKey: "swingmate.install_id") ?? UUID().uuidString
    defaults.set(deviceId, forKey: "swingmate.install_id")
    result([
      "deviceId": deviceId,
      "deviceName": device.model,
      "platform": "IOS",
      "appVersion": version ?? "unknown"
    ])
  }
}
