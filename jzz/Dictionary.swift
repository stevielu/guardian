//
//  Dictionary.swift
//  jzz
//
//  Created by wei lu on 24/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
