//
//  AddNewButton.swift
//  jzz
//
//  Created by wei lu on 15/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class AddNewButton:UIButton {
    required init(value: String = "Add Emergency Contact") {
        
        super.init(frame: .zero)
        
        // set other operations after super.init, if required
        self.backgroundColor = UIColor.white
        self.setTitleColor(globalStyle.titleColor, for: .normal)
        self.contentHorizontalAlignment = .left
        self.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(10, -12.5, 10, 0)
        self.imageView?.contentMode = .scaleAspectFit
        semanticContentAttribute = .forceLeftToRight
        self.setImage(UIImage(named:"add"), for: .normal)
        self.setTitle(value, for: .normal)
        self.titleLabel?.font = globalStyle.titleFont
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
