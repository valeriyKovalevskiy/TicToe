//
//  AVDYandexManager.swift
//  AdvDemoApp
//
//  Created by Artyom Lihach on 10/12/2018.
//  Copyright © 2018 Artyom. All rights reserved.
//

import UIKit
import YandexMobileMetrica
import YandexMobileMetricaPush
import UserNotifications

// More details:
// https://tech.yandex.ru/appmetrica/doc/mobile-sdk-dg/tasks/swift-quickstart-docpage/
// https://tech.yandex.ru/appmetrica/doc/mobile-sdk-dg/push/swift-initialize-docpage/

class AVDYandexManager {
    
    static let sharedInstance = AVDYandexManager()
    private let apiKey = kYandexApiKey
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        YMMYandexMetrica.activate(with: YMMYandexMetricaConfiguration.init(apiKey: apiKey)!)
        
        YMPYandexMetricaPush.handleApplicationDidFinishLaunching(options: launchOptions)
        
        
        // Register for push notifications
        if #available(iOS 10.0, *) {
            // iOS 10.0 and above
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
        } else {
            // iOS 9
            let settings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        if #available(iOS 10.0, *) {
            let delegate = YMPYandexMetricaPush.userNotificationCenterDelegate()
            UNUserNotificationCenter.current().delegate = delegate
        }
    }
    
    func register(forRemoteNotification deviceToken: Data) {
        #if DEBUG
            let pushEnvironment = YMPYandexMetricaPushEnvironment.development
        #else
            let pushEnvironment = YMPYandexMetricaPushEnvironment.production
        #endif
        YMPYandexMetricaPush.setDeviceTokenFrom(deviceToken, pushEnvironment: pushEnvironment)
    }
    
    func handle(remoteNotification userInfo: Dictionary<AnyHashable, Any>) {
        YMPYandexMetricaPush.handleRemoteNotification(userInfo)
    }
    
}
