//
//  DetailsHeader.swift
//  jzz
//
//  Created by wei lu on 17/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class DetailHearder: UIView {
    lazy var avatar:UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 6
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        
        return image
    }()
    
    lazy var fullName:UILabel = {
        var name = UILabel()
        name.textAlignment = .left
        name.font = globalStyle.titleFont
        name.textColor = globalStyle.titleColor
        
        return name
    }()
    
    lazy var userName:UILabel = {
        var name = UILabel()
        name.textAlignment = .left
        name.font = globalStyle.subtitleFont
        name.textColor = globalStyle.subtitleColor
        
        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(frame: CGRect,profile:UIImage,title:String,id:String) {
        self.init(frame: frame)
        self.addSubview(self.avatar)
        self.addSubview(self.fullName)
        self.addSubview(self.userName)
        
        self.avatar.image = profile
        self.fullName.text = title
        self.userName.text = id
        
        layout(relative: self)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func layout(relative:UIView){
        self.avatar.snp.makeConstraints { (make) in
            make.centerY.equalTo(relative.snp.centerY)
            make.left.equalTo(relative.snp.left).offset(12.5)
            make.height.width.equalTo(45)
        }
        
        self.fullName.snp.makeConstraints { (make) in
            make.top.equalTo(relative.snp.top).offset(5)
            make.left.equalTo(avatar.snp.right).offset(12.5)
        }
        
        self.userName.snp.makeConstraints { (make) in
            make.bottom.equalTo(relative.snp.bottom).offset(-5)
            make.left.equalTo(avatar.snp.right).offset(12.5)
        }
        
    }
    
    
}
