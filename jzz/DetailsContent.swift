//
//  DetailsContent.swift
//  jzz
//
//  Created by wei lu on 17/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class DetailsContent: UIView {
    
    
    lazy var address:UILabel = {
        var name = UILabel()
        name.textAlignment = .left
        name.font = globalStyle.titleFont
        name.textColor = globalStyle.titleColor
        name.text = "Address"
        return name
    }()
    
    lazy var mobile:UILabel = {
        var name = UILabel()
        name.textAlignment = .left
        name.font = globalStyle.titleFont
        name.textColor = globalStyle.titleColor
        name.text = "Mobile"
        return name
    }()
    
    lazy var addressValue:UILabel = {
        var name = UILabel()
        name.textAlignment = .left
        name.font = globalStyle.titleFont
        name.textColor = globalStyle.titleColor
        self.addBottomBorder(Objview: name)
        return name
    }()
    
    lazy var mobileValue:UILabel = {
        var name = UILabel()
        name.textAlignment = .left
        name.font = globalStyle.titleFont
        name.textColor = globalStyle.titleColor
        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(frame: CGRect,address:String,mobile:String) {
        self.init(frame: frame)
        self.addSubview(self.address)
        self.addSubview(self.mobile)
        self.addSubview(self.addressValue)
        self.addSubview(self.mobileValue)
        
        self.addressValue.text = address
        self.mobileValue.text = mobile
        
        layout(relative: self)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func layout(relative:UIView){
        self.address.snp.makeConstraints { (make) in
            make.top.equalTo(relative.snp.top).offset(5)
            make.left.equalTo(relative.snp.left).offset(12.5)
            make.height.equalTo(35)
            make.width.equalTo(75)
        }
        
        self.mobile.snp.makeConstraints { (make) in
            make.top.equalTo(address.snp.bottom)
            make.left.equalTo(relative.snp.left).offset(12.5)
            make.height.equalTo(35)
            make.width.equalTo(75)
        }
        
        self.addressValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.address.snp.centerY)
            make.left.equalTo(self.address.snp.right)
            make.right.equalTo(relative.snp.right)
            make.height.equalTo(35)
            
        }
        
        self.mobileValue.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.mobile.snp.centerY)
            make.left.equalTo(self.mobile.snp.right)
            make.right.equalTo(relative.snp.right)
            make.height.equalTo(35)
            
        }
        
    }
    
    @objc fileprivate func addBottomBorder(Objview:UIView){
        let border = UIView()
        
        border.layer.borderWidth = 0.5
        border.layer.borderColor = UIColor(rgb:0xdddddd).cgColor
        Objview.addSubview(border)
        border.snp.makeConstraints{(make) in
            make.top.equalTo(Objview.snp.bottom)
            make.left.equalTo(Objview.snp.left)
            make.right.equalTo(Objview.snp.right)
            make.height.equalTo(0.5)
        }
    }
}
