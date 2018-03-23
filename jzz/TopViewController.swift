//
//  TopViewController.swift
//  jzz
//
//  Created by wei lu on 19/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        return viewController
    }
    
    class func createLocalNotification(content:String){
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 2) as Date
        notification.alertBody = "content"
        notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.shared.scheduleLocalNotification(notification)
    }
}
