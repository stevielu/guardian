//
//  File.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit

class SettingIcon{
    var head:UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.layer.masksToBounds = false
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(named:"device")
        return icon
    }()
    
    var checked:UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.layer.masksToBounds = false
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(named:"check_box_checked")
        return icon
    }()
    
    var unChecked:UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.layer.masksToBounds = false
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(named:"check_box")
        return icon
    }()
    
    var alarmaLabel:UILabel = {
        let label = UILabel()
        label.text = "Alarm Status"
        label.font = globalStyle.subtitleFont
        label.textColor = globalStyle.titleColor
        return label
    }()
    
    var one:UILabel = {
        let label = UILabel()
        label.text = "One Press"
        label.font = globalStyle.subtitleFont
        label.textColor = globalStyle.titleColor
        return label
    }()
    
    var two:UILabel = {
        let label = UILabel()
        label.text = "Two Press"
        label.font = globalStyle.subtitleFont
        label.textColor = globalStyle.titleColor
        return label
    }()
    
    var three:UILabel = {
        let label = UILabel()
        label.text = "Three Press"
        label.font = globalStyle.subtitleFont
        label.textColor = globalStyle.titleColor
        return label
    }()
}
