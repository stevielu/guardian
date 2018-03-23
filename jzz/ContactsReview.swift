//
//  ContactsReview.swift
//  jzz
//
//  Created by wei lu on 16/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import SwiftyJSON

class ContactsReview {
    var ProfilePhoto:String?
    var FullName = ""
    var Mobile = ""
    var Address = ""
    var Gender = ""
    var UserName = ""
    init(JSONData:JSON?){
        if(JSONData != nil){
            self.ProfilePhoto = JSONData!["avatar"].stringValue
            self.FullName = JSONData!["full_name"].stringValue
            self.Mobile = JSONData!["mobile"].stringValue
            self.Address = JSONData!["address"].stringValue
            self.Gender = JSONData!["gender"].stringValue
            self.UserName = JSONData!["user_name"].stringValue
        }
    }
}
