//
//  NotificationCenter.swift
//  jzz
//
//  Created by wei lu on 21/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

class JzzNotificationCenter{
     static public func registerDevice(token:String,user:String){
        let server = ServiceDataProcess()
        let data = httpData()
        data.Httpmethod = .post
        data.data = [
            "UserName":user,
            "DeviceToken":token
        ]
        server.httpAct(requestUrl: UPDATE_DEVICE_TOKEN, Senddata: data, completion: {ret in
            //print(JSON(ret))
        })
    }
    
    
    public func setTabBadge(){
        if let top = UIApplication.topViewController(){
            if let svc = top.tabBarController?.viewControllers![1]{
                svc.tabBarItem.badgeValue = " "
            }
            
        }
    }
    
}
