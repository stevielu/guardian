//
//  UserProfileModel.swift
//  jzz
//
//  Created by wei lu on 3/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class DBUserProfile: Object {
    // Specify properties to ignore (Realm won't persist these)
    dynamic var userName:String?
    dynamic var FullName:String?
    dynamic var Address:String?
    dynamic var Gender:String?
    dynamic var Age = 0
    dynamic var Mobile = 0
    dynamic var Avatar:String?
    dynamic var Email:String?
}

class ProfileModel {
    var user:String!
    
    init(user:String!) {
        self.user = user
    }
    
    //Method
    
    /*
     *Description: Set Profile Value to Local Realm db
     *Return: Bool
     *Parameter: Json
     */
    func store(data:UserProfile) -> Bool {
        let results = uiRealm.objects(DBUserProfile.self).filter("userName = %@",self.user)
        guard let realm = try? Realm() else {
            return false
        }
        if(results.first == nil ){//create
            
            try! realm.write {
                let newUser = DBUserProfile()
                newUser.FullName = data.Fullname
                newUser.Address = data.Address
                newUser.userName = self.user
                newUser.Gender = data.Gender
                newUser.Age = data.Age!
                newUser.Avatar = data.Avatar
                newUser.Email = data.Email
                newUser.Mobile = data.Mobile!
                realm.add(newUser)
            }
            
        }
        else{//update
            try! realm.write {
                results.first?.FullName = data.Fullname
                results.first?.Address = data.Address
                results.first?.Gender = data.Gender
                results.first?.Age = data.Age!
                results.first?.Avatar = data.Avatar
                results.first?.Email = data.Email
                results.first?.Mobile = data.Mobile!
                //results.first?.addressId = json["ProviderAddressId"].stringValue
            }
        }
        return true
    }
    
    
    /*
     *Description: Get Profile Value to Local Realm db
     *Return: User Profile Calss
     *Parameter: User name
     */
    func get() -> DBUserProfile? {
        let results = uiRealm.objects(DBUserProfile.self).filter("userName = %@",self.user)
        return results.first
    }
    
    /*
     *Description: Update Profile Value to Local Realm db
     *Return: User Profile Calss
     *Parameter: User name
     */
    func update(key:String,value:Any) -> Bool? {
        guard let realm = try? Realm() else {
            return false
        }
        let results = uiRealm.objects(DBUserProfile.self).filter("userName = %@",self.user)
        try! realm.write {
            results.first?.setValue(value, forKeyPath: key)
        }
        return true
    }
}
