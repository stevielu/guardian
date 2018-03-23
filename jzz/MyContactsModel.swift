//
//  MyContactsModel.swift
//  jzz
//
//  Created by wei lu on 17/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class DBUserContacts: Object {
    // Specify properties to ignore (Realm won't persist these)
    dynamic var userName:String?
    let contacts = List<DBContactDetials>()
    
}

class DBContactDetials:Object{
    dynamic var Fullname:String?
    dynamic var Address:String?
    dynamic var Gender:String?
    dynamic var Avatar:String?
    dynamic var Mobile:String?
    dynamic var FriUserName:String?
}

class ContactsModel {
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
    func store(data:ContactsReview) -> Bool {
        let results = uiRealm.objects(DBUserContacts.self).filter("userName = %@",self.user)
        guard let realm = try? Realm() else {
            return false
        }
        
        //Set up Value
        let newContent = DBContactDetials()
        newContent.Fullname = data.FullName
        newContent.Address = data.Address
        newContent.FriUserName = data.UserName
        newContent.Gender = data.Gender
        newContent.Avatar = data.ProfilePhoto
        newContent.Mobile = data.Mobile
        
        if(results.first == nil ){//create
            
            try! realm.write {
                let newUser = DBUserContacts()
                newUser.userName = self.user
                realm.add(newUser)
                newUser.contacts.append(newContent)
                
            }
            
        }
        else{//update
            try! realm.write {
                results.first?.contacts.append(newContent)
            }
        }
        return true
    }
    
    
    /*
     *Description: Get Profile Value to Local Realm db
     *Return: User Profile Calss
     *Parameter: User name
     */
    func get() -> [DBContactDetials]? {
        let results = uiRealm.objects(DBUserContacts.self).filter("userName = %@",self.user)
        if(results.first != nil){
            let contents:List<DBContactDetials> = (results.first?.contacts)!
            return Array(contents)
        }else{
            return nil
        }
        
    }
    
    /*
    *Description: FLush Value to Local Realm db
    *Return: User Profile Calss
    *Parameter: User name
    */
    func flush() -> Bool {
        let results = uiRealm.objects(DBUserContacts.self).filter("userName = %@",self.user)
        guard let realm = try? Realm() else {
            return false
        }
        if(results.first != nil){
            try! realm.write {
                realm.delete(results.first!)
            
            }
            return true
        }else{
            return false
        }
        
    }
}
