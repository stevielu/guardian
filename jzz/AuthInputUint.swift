//
//  AuthInputUint.swift
//  jzz
//
//  Created by wei lu on 20/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class AuthInputUnit{
    
    
    // MARK:
    lazy var userNameInput:UITextField = {
        var code = UITextField()
        var icon = UIImageView(image: UIImage(named: "full_name"))
        icon.contentMode = .scaleAspectFit
        
        code.placeholder = "User Name/Phone Number"
        code.textAlignment = .center
        code.leftView = self.addPaddingForLeftView(image: icon)
        code.leftViewMode = UITextFieldViewMode.always
        code.returnKeyType = .done
        code.font = globalStyle.titleFont
        self.addBottomBorder(Objview: code)
        return code
    }()
    
    lazy var passInput:UITextField = {
        var code = UITextField()
        var icon = UIImageView(image: UIImage(named: "lock"))
        icon.contentMode = .scaleAspectFit
        
        code.isSecureTextEntry = true
        code.placeholder = "Enter Your Password"
        code.textAlignment = .center
        code.leftView = self.addPaddingForLeftView(image: icon)
        code.leftViewMode = UITextFieldViewMode.always
        code.returnKeyType = .done
        code.font = globalStyle.titleFont
        self.addBottomBorder(Objview: code)
        return code
    }()
    
    
    lazy var tips:UILabel = {
        var tip = UILabel()
        tip.font = globalStyle.subtitleFont
        tip.textColor = globalStyle.subtitleColor
        tip.lineBreakMode = .byWordWrapping
        tip.numberOfLines = 0
        return tip
    }()
    
    fileprivate func addPaddingForLeftView(image:UIImageView) -> UIView{
        let leftView = UIView()
        leftView.addSubview(image)
        leftView.frame = CGRect(x:0, y:0, width:0, height:20)
        image.frame = CGRect(x:-25, y:0, width:15, height:20)
        return leftView
    }
    
    
    func addBottomBorder(Objview:UIView){
        let border = UIView()
        
        border.layer.borderWidth = 0.5
        border.layer.borderColor = globalStyle.titleColor.cgColor
        Objview.addSubview(border)
        border.snp.makeConstraints{(make) in
            make.top.equalTo(Objview.snp.bottom).offset(5)
            make.left.equalTo(Objview.snp.left)
            make.right.equalTo(Objview.snp.right)
            make.height.equalTo(0.5)
        }
    }
    
    
    
}
