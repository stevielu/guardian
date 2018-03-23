//
//  SettingData.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
class SettingData {
    var attribute:[[String]]!
    
    init(){
        setUp()
    }
    
    fileprivate func setUp(){
        self.attribute = [
            [
                "Emergency Contact",
                "Personal Setting"
            ],
            [
               "Logout"
            ]
        ]
    }
}
