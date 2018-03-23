//
//  ClientProfile.swift
//  Provider
//
//  Created by imac on 19/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation
import SwiftyJSON


class UserProfile{
    let Fullname : String?
    let Address : String?
    let Gender : String?
    let Age : Int?
    let Avatar : String?
    let Email:String?
    let Mobile: Int?

    init(JSONData data:JSON) {
        self.Fullname = data["full_name"].stringValue
        self.Address = data["address"].stringValue
        self.Gender = data["gender"].stringValue
        self.Age = data["age"].intValue
        self.Avatar = data["avatar"].stringValue
        self.Email = data["email"].stringValue
        self.Mobile = data["mobile"].intValue
    }
}
