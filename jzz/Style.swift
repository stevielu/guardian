//
//  Style.swift
//  jzz
//
//  Created by wei lu on 2/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit

class globalStyle {
    //width & height
    static var screenSize: CGRect = UIScreen.main.bounds
    static let start = screenSize.width/3
    
    //font

    static let titleColor = UIColor(rgb:0x5F646A)
    static let subtitleColor = UIColor(rgb:0xACACAC)
    static let buttonTitleColor = UIColor(rgb:0xFFFFFF)
    static let titleFont = UIFont(name:"Myriad",size: 16.0)
    static let subtitleFont = UIFont(name:"Myriad",size: 12.0)
    static let tinytitleFont = UIFont(name:"Myriad",size: 10.0)
    //color
    static let buttonFillColorRed = UIColor(rgb:0xEF766F)
    static let buttonFillColorBlue = UIColor(rgb:0x9CCFF0)
    static let buttonOutLineColor = UIColor(rgb:0x49B04E)
    static let backgroundColor = UIColor(rgb:0xF7F7F7)//FF5A5F da5a58 df6f6d
    
    //thickness
    static let thickness:CGFloat = 0.5
    
    //image size
    static let avatarSize =  CGSize(width: 50, height: 50)
    static let myProfileSize =  CGSize(width: 100, height: 100)
    static let arrowSize =  CGSize(width: 25, height: 25)
    static let imageCompressMaxSize = 300
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
