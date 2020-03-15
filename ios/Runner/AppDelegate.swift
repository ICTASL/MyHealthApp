import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let locationChannel = FlutterMethodChannel(name: "location", binaryMessenger: controller.binaryMessenger)
    
    locationChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // Note: this method is invoked on the UI thread.
      guard call.method == "getLocation" else {
        result(FlutterMethodNotImplemented)
        return
      }
        
      let location = self?.getLocationUpdate()
        
      if location == nil {
        result(FlutterError(code: "Unavailable",
                            message: "Location is not available",
                            details: nil))
      } else {
        result(location)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
  private func getLocationUpdate() -> String? {
    let location = "FROM SERVER"
    return location
  }
}
