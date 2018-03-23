//
//  Alert.swift
//  jzz
//
//  Created by wei lu on 19/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit

class AlertUtil: NSObject {
    static func showCancelAlert(_ title: String, message: String, cancelTitle: String, viewController: UIViewController,handler:((UIAlertAction) -> Swift.Void)? = nil) {
        // The system version is less than 9.0
        if UIDevice.current.systemVersion.compare("9.0.0", options: NSString.CompareOptions.numeric) == .orderedAscending {
            UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: cancelTitle).show()
        } else { // The system version is greate than or equal 9.0
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: handler))
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func createLocalNotification(content:String){
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 2) as Date
        notification.alertBody = content
        notification.alertAction = "Alert"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.shared.scheduleLocalNotification(notification)
        
    }
        
}
