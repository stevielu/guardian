//
//  GetProfile.swift
//  jzz
//
//  Created by wei lu on 24/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProfileAction: NSObject {
    
    static func fetchProfile(activeUser:String,handel:@escaping ((Any) -> Void)){
        let http = ServiceDataProcess()
        let request = httpData()
        request.data = ["UserName":activeUser]
        request.Httpmethod = .post
        http.httpAct(requestUrl: GET_PROFILE, Senddata: request){(ret) in
            if(JSON(ret) != false){
                let data = JSON(ret)
                let profile = UserProfile(JSONData: data)
                let profileDB = ProfileModel(user: activeUser)
                profileDB.store(data: profile)
            }
            handel(ret)
        }
    }
    
    static func updateProfile(activeUser:String,value:[String:Any],handel:@escaping ((Any) -> Void)){
        let http = ServiceDataProcess()
        let request = httpData()
        request.data = ["UserName":activeUser]
        request.data.update(other: value)
        request.Httpmethod = .post
        http.httpAct(requestUrl: UPDATE_PROFILE, Senddata: request){(ret) in
            if(JSON(ret) != false){
                let data = JSON(ret)
                let profile = UserProfile(JSONData: data)
                let profileDB = ProfileModel(user: activeUser)
                let key = Array(value.keys)[0]
                profileDB.update(key:key, value: value[key])
            }
            handel(ret)
        }
    }
}
