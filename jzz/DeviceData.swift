//
//  DeviceData.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation

class DeviceData {
    var attribute:[String]!

    init(){
        setUp()
    }
    
    fileprivate func setUp(){
        self.attribute = [
            "Alva Status",
            "Device Gesture"
        ]
    }
}
