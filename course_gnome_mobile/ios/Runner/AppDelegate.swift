import UIKit
import Flutter
import FacebookCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
	override func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
		) -> Bool {
		GeneratedPluginRegistrant.register(with: self)
		//	return SDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
		return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	}
	// fb
	override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		return SDKApplicationDelegate.shared.application(app, open: url, options: options)
	}
}
