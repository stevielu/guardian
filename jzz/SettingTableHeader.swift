//
//  TableHeader.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SettingHead: UIView {
    lazy var avatar:UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(frame: CGRect,profile:UIImage) {
        self.init(frame: frame)
        self.addSubview(self.avatar)
        
        self.avatar.image = profile

        layout(relative: self)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func layout(relative:UIView){

        
        
    }
    
    
}
