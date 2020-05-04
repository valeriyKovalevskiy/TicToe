//
//  AppDelegate.swift

import UIKit
import UserNotifications
import FacebookCore
import FBSDKCoreKit
import AppsFlyerLib
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerTrackerDelegate, UNUserNotificationCenterDelegate {
    
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {}
    func onConversionDataFail(_ error: Error) {}
    
	
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
		
		if launchOptions?[UIApplication.LaunchOptionsKey.url] == nil {
			AppLinkUtility.fetchDeferredAppLink { (url, error) in
				if let url = url, url.query != nil  {
					print("\(url.absoluteString)")
					UserDefaults.standard.set(url.query, forKey: kSettingParams)
					UserDefaults.standard.synchronize()
				} else {
					print("No deeplink")
				}
			}
		}
		
		
		AppsFlyerTracker.shared().appsFlyerDevKey = kAppsFlayerDevKey
		AppsFlyerTracker.shared().appleAppID = kAppId
		AppsFlyerTracker.shared().delegate = self
		#if DEBUG
		AppsFlyerTracker.shared().isDebug = true
		#endif
		let appsflyerId = AppsFlyerTracker.shared().getAppsFlyerUID()
		UserDefaults.standard.set(appsflyerId, forKey: kSettingAppsflayerUserId)
		UserDefaults.standard.synchronize()
		
		FirebaseApp.configure()
		
		if #available(iOS 10.0, *) {
			// For iOS 10 display notification (sent via APNS)
			UNUserNotificationCenter.current().delegate = self
			
			let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
			UNUserNotificationCenter.current().requestAuthorization(
				options: authOptions,
				completionHandler: {_, _ in })
		} else {
			let settings: UIUserNotificationSettings =
				UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
			application.registerUserNotificationSettings(settings)
		}
		
		application.registerForRemoteNotifications()
		
		return true
	}
	
	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		if let rootViewController = self.window?.rootViewController {
			if rootViewController.isKind(of: UINavigationController.self) {
				return [.portrait]
			} else {
				return [.all]
			}
		} else {
			return [.portrait]
		}
	}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
		return handled
	}

	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		completionHandler(.newData)
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		AppEvents.activateApp();
		AppsFlyerTracker.shared().trackAppLaunch()
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		
	}
}

