//
//  Logout.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit

class LogoutAlert: NSObject {
    static func showLogoutAlert(_ title: String, message: String, cancelTitle: String, viewController: UIViewController,handler:((UIAlertAction) -> Swift.Void)? = nil) {
        // The system version is less than 9.0
        
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            }
            
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                JzzNotificationCenter.registerDevice(token: "", user: UserDefaults.standard.object(forKey: "ActiveUser") as! String)
                UserDefaults.standard.removeObject(forKey: "ActiveUser")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginNVC = storyboard.instantiateViewController(withIdentifier: "regNVC") as! JZZNavgationViewController
                let appDelgate = UIApplication.shared.delegate as! AppDelegate
                appDelgate.window?.rootViewController = loginNVC
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            viewController.present(alertController, animated: true, completion: nil)
    }
}
