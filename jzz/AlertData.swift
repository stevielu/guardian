//
//  AlertData.swift
//  jzz
//
//  Created by wei lu on 21/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import SwiftyJSON

class AlertData {
    var ProfilePhoto:String?
    var ID:Int?
    var FullName = ""
    var Age:Int!
    var Address = ""
    var Gender = ""
    var Lat = ""
    var Lon = ""
    init(JSONData:JSON?){
        if(JSONData != nil){
            self.ProfilePhoto = JSONData!["avatar"].stringValue
            self.ID = JSONData!["alert_id"].intValue
            self.FullName = JSONData!["full_name"].stringValue
            self.Age = JSONData!["age"].intValue
            self.Address = JSONData!["address_formated"].stringValue
            self.Gender = JSONData!["gender"].stringValue
            self.Lat = JSONData!["current_lat"].stringValue
            self.Lon = JSONData!["current_lon"].stringValue
        }
    }
}
