//
//  AppDelegate.swift
//  jzz
//
//  Created by admin on 31/03/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Firebase
import FirebaseMessaging
import NexmoVerify
import FirebaseInstanceID
import CoreBluetooth
let uiRealm = try! Realm()
var characteristicGlobal : CBCharacteristic?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var nexmoAppId = "c6f9a00c-8ba9-49c5-b696-b0e1ba8cbc08"
    var nexmoSecurityKey = "f036f7d22b675ea"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //sms verify
        NexmoClient.start(applicationId: self.nexmoAppId, sharedSecretKey: self.nexmoSecurityKey)
        
        //Bluetooth 
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(_:)), name: nil, object: BluetoothManager.getInstance())
        
        //firbase message initial
    
        
        
        FIRApp.configure()
        let notificationTypes:UIUserNotificationType = [UIUserNotificationType.alert,UIUserNotificationType.badge,UIUserNotificationType.sound]
        let notificationSetting = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(notificationSetting)
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(self.devicetokenRefreshNotification),
                                                         name: NSNotification.Name.firInstanceIDTokenRefresh,
                                                         object: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNVC = storyboard.instantiateViewController(withIdentifier: "regNVC") as! JZZNavgationViewController
        let appDelgate = UIApplication.shared.delegate as! AppDelegate
        
        //auth
        if let activeUser = UserDefaults.standard.object(forKey: "ActiveUser") as? String{//{
            ProfileAction.fetchProfile(activeUser: activeUser, handel: {(ret) in
                let packet = JSON(ret)
                if(packet == false){
                    appDelgate.window?.rootViewController = loginNVC
                }
                else{
                    let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarView") as! JZZTabBarViewController
                    appDelgate.window?.rootViewController = tabBarController
                }
            })
        }else{
            appDelgate.window?.rootViewController = loginNVC
        }
        
        
        
        //Device Config
        if UserDefaults.standard.object(forKey: "DeviceConfig") == nil {
            let config = ["PressGesture":["Press1":true,"Press2":false,"Press3":false]]
            UserDefaults.standard.set(config, forKey: "DeviceConfig")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        FIRMessaging.messaging().disconnect()
        print("Disconn@objc ected from FCM.")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFcm()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //Bluetooth 
    func handleNotification(_ notif: Notification) {
        let homeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TrackView") as! TrackViewController
        
        switch notif.name {
        case NSNotification.Name(rawValue: PeripheralNotificationKeys.DisconnectNotif.rawValue):
            print("\(PeripheralNotificationKeys.DisconnectNotif.rawValue)")
            if let topController = UIApplication.topViewController() {
                AlertUtil.showCancelAlert("Disconnected Alert", message: "The peripheral has disconnected", cancelTitle: "Dismiss", viewController: topController)
                
            }
        case NSNotification.Name(rawValue: PeripheralNotificationKeys.TimeOutNotif.rawValue):
            if let topController = UIApplication.topViewController() {
                AlertUtil.showCancelAlert("Timeout Alert", message: "Connection Timeout", cancelTitle: "Dismiss", viewController: topController)
            }
            break
        default:
            print("default")
        }
    
        
    }
    
    //messageing
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.prod)
        
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        let noti = JzzNotificationCenter()
        noti.setTabBadge()
        if let topController = UIApplication.topViewController() as? AlertlistTableViewController{
            topController.tableView.reloadData()
        }
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 1
    }
    
    @objc func devicetokenRefreshNotification() {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            let token = UserDefaults.standard
            token.set(refreshedToken, forKey: "NoticInstanceID")
            
            if let activeUser = UserDefaults.standard.object(forKey: "ActiveUser") as? String{
                //register device  token
//                let notiCenter = JzzNotificationCenter()
                JzzNotificationCenter.registerDevice(token: refreshedToken, user: activeUser)
            }
        }
        connectToFcm()
        // Connect to FCM since connection may have failed when attempted before having a token.
    }
    
    func connectToFcm() {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            let token = UserDefaults.standard
            token.set(refreshedToken, forKey: "NoticInstanceID")
            print("InstanceID token: \(refreshedToken)")
            if let activeUser = UserDefaults.standard.object(forKey: "ActiveUser") as? String{
                //register device  token
                //let notiCenter = JzzNotificationCenter()
                JzzNotificationCenter.registerDevice(token: refreshedToken, user: activeUser)
            }
        }
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
}

