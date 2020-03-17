import UIKit
import Flutter
import CoreLocation
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
  let locationManager = CLLocationManager()
  
  var isSupportingLocationUpdates = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    isSupportingLocationUpdates = CLLocationManager.significantLocationChangeMonitoringAvailable()
    if (isSupportingLocationUpdates) {
      locationManager.requestAlwaysAuthorization()
      if #available(iOS 9.0, *) {
        locationManager.allowsBackgroundLocationUpdates = true
      }
      locationManager.delegate = self
      startLocationUpdate()
    }
    
    let controller = window?.rootViewController as! FlutterViewController
    let locationChannel = FlutterMethodChannel(name: "location", binaryMessenger: controller.binaryMessenger)
    
    locationChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // Note: this method is invoked on the UI thread.
      
      if !(self?.isSupportingLocationUpdates ?? false) {
        result(FlutterError(code: "Unavailable",
                            message: "Location is not available",
                            details: nil))
        return
      }
      
      if call.method == "getLocation" {
        result(self?.getLocation())
      } else if call.method == "startLocationUpdates" {
        self?.startLocationUpdate()
      } else if call.method == "stopLocationUpdates" {
        self?.stopLocationUpdate()
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    
	// Messaging
	if #available(iOS 10.0, *) {
	  UNUserNotificationCenter.current().delegate = self
	}

	// Google Maps
    GMSServices.provideAPIKey("AIzaSyBQu2WwoTFKJQ1PM4w-hIRkLnEVDtWtFoo")
	
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locations.forEach { (location) in
      LocationsStorage.shared.saveLocationOnDisk(location: Location(location.coordinate, date: location.timestamp))
    }
  }
  
  private func getLocation() -> [String] {
    let encoder = JSONEncoder()
    return LocationsStorage.shared.locations.map { (location) -> String in
      guard let data = try? encoder.encode(location) else {
        return ""
      }
      return String(data: data, encoding: .utf8)!
    }
  }
  
  private func startLocationUpdate() {
    locationManager.startMonitoringSignificantLocationChanges()
  }
  
  private func stopLocationUpdate() {
    locationManager.stopMonitoringSignificantLocationChanges()
  }
}
