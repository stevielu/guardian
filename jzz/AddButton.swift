//
//  AddButton.swift
//  jzz
//
//  Created by wei lu on 17/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class AddButton: UIButton {
    required init(value: String = "Add") {
        
        super.init(frame: .zero)
        
        // set other operations after super.init, if required
        backgroundColor = globalStyle.buttonFillColorRed
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = 6.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = globalStyle.backgroundColor.cgColor
        self.clipsToBounds = true
        self.setTitle(value, for: .normal)
        self.titleLabel?.font = globalStyle.titleFont
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func startAnimate(){
        self.pleaseWait()
    }
    
    func stopAnimate(){
        self.clearAllNotice()
    }
}
