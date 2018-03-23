//
//  PersonalData.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
enum EditType {
    case Text
    case Selection
    case Numeric
    case Email
}
class PersonalData {
    var attribute:[String:[String:Any]]!
    
    init(){
        setUp()
    }
    
    fileprivate func setUp(){
        self.attribute =
            [
                "FullName":["Editable":true,"Type":EditType.Text,"Value":"default"],
                "Gender":["Editable":true,"Type":EditType.Selection,"Value":"default"],
                "Age":["Editable":true,"Type":EditType.Numeric,"Value":"default"],
                "Mobile":["Editable":false,"Type":EditType.Numeric,"Value":"default"],
                "Email":["Editable":true,"Type":EditType.Email,"Value":"default"],
                "Address":["Editable":true,"Type":EditType.Text,"Value":"default"],
                
            ]
    }
}
