//
//  RegisterInputLine.swift
//  jzz
//
//  Created by wei lu on 4/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class RegisterInputUnit{
    
    
    // MARK:
    //Verify Input
    
    lazy var countryCodeInput:UITextField = {
        var countryInput = UITextField()
        var icon = UIImageView(image: UIImage(named: "Cellphone"))
        icon.contentMode = .scaleAspectFit
        countryInput.placeholder = "Country Code"
        countryInput.textAlignment = .center
        countryInput.font = globalStyle.titleFont
        countryInput.leftView = self.addPaddingForLeftView(image: icon)
        countryInput.leftViewMode = UITextFieldViewMode.always
        countryInput.returnKeyType = .done
        
        
        self.addBottomBorder(Objview: countryInput)
       return countryInput
    }()
    
    lazy var phoneInput:UITextField = {
        var phone = UITextField()
        phone.placeholder = "Phone Number"
        phone.textAlignment = .center
        phone.font = globalStyle.titleFont
        phone.returnKeyType = .done
        phone.keyboardType = .numberPad
        self.addBottomBorder(Objview: phone)
        return phone
    }()
    
    lazy var smsCodeInput:UITextField = {
        var code = UITextField()
        var icon = UIImageView(image: UIImage(named: "veri_lock"))
        icon.contentMode = .scaleAspectFit
        
        code.placeholder = "Enter Your Code"
        code.textAlignment = .center
        code.leftView = self.addPaddingForLeftView(image: icon)
        code.leftViewMode = UITextFieldViewMode.always
        code.returnKeyType = .done
        code.font = globalStyle.titleFont
        self.addBottomBorder(Objview: code)
        return code
    }()
    
    
    // Mark:
    // Register
    
    lazy var userNameInput:UITextField = {
        var code = UITextField()
        var icon = UIImageView(image: UIImage(named: "full_name"))
        icon.contentMode = .scaleAspectFit
        
        code.placeholder = "User Name"
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
        var icon = UIImageView(image: UIImage(named: "un_lock"))
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
    
    lazy var confirmInput:UITextField = {
        var code = UITextField()
        var icon = UIImageView(image: UIImage(named: "un_lock"))
        icon.contentMode = .scaleAspectFit
        
        code.isSecureTextEntry = true
        code.placeholder = "Confirm Your Password"
        code.textAlignment = .center
        code.leftView = self.addPaddingForLeftView(image: icon)
        code.leftViewMode = UITextFieldViewMode.always
        code.returnKeyType = .done
        code.font = globalStyle.titleFont
        self.addBottomBorder(Objview: code)
        return code
    }()
    
    // Mark:
    // Profile
    
    lazy var emailInput:UITextField = {
        var code = UITextField()
        var icon = UIImageView(image: UIImage(named: "mail"))
        icon.contentMode = .scaleAspectFit
        
        code.placeholder = "Email Address"
        code.textAlignment = .center
        code.leftView = self.addPaddingForLeftView(image: icon)
        code.leftViewMode = UITextFieldViewMode.always
        code.returnKeyType = .done
        code.font = globalStyle.titleFont
        self.addBottomBorder(Objview: code)
        return code
    }()
    
    lazy var fullNameInput:UITextField = {
        var code = UITextField()
        var icon = UIImageView(image: UIImage(named: "full_name"))
        icon.contentMode = .scaleAspectFit
        
        code.placeholder = "Your Full Name"
        code.textAlignment = .center
        code.leftView = self.addPaddingForLeftView(image: icon)
        code.leftViewMode = UITextFieldViewMode.always
        code.returnKeyType = .done
        code.font = globalStyle.titleFont
        self.addBottomBorder(Objview: code)
        return code
    }()
    
    lazy var genderInput:UITextField = {
        var code = UITextField()
        var icon = UIImageView(image: UIImage(named: "gender"))
        icon.contentMode = .scaleAspectFit
        
        code.placeholder = "Gender"
        code.textAlignment = .center
        code.leftView = self.addPaddingForLeftView(image: icon)
        code.leftViewMode = UITextFieldViewMode.always
        code.returnKeyType = .done
        code.font = globalStyle.titleFont
        self.addBottomBorder(Objview: code)
        return code
    }()
    
    lazy var ageInput:UITextField = {
        var code = UITextField()
        var icon = UIImageView(image: UIImage(named: "age"))
        icon.contentMode = .scaleAspectFit
        
        code.placeholder = "Age"
        code.textAlignment = .center
        code.leftView = self.addPaddingForLeftView(image: icon)
        code.leftViewMode = UITextFieldViewMode.always
        code.returnKeyType = .done
        code.font = globalStyle.titleFont
        self.addBottomBorder(Objview: code)
        return code
    }()
    
    lazy var homeAddressInput:UITextField = {
        var code = UITextField()
        var icon = UIImageView(image: UIImage(named: "home"))
        icon.contentMode = .scaleAspectFit
        
        code.placeholder = "Home Address"
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

