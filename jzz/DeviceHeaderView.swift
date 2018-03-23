//
//  DeviceHeaderView.swift
//  jzz
//
//  Created by wei lu on 23/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class DeviceTableHeader: UIView {
    lazy var icon:UIImageView = {
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
        self.addSubview(self.icon)
        
        
        self.icon.image = profile
        
        layout(relative: self)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func layout(relative:UIView){
        self.icon.snp.makeConstraints { (make) in
            make.centerY.equalTo(relative.snp.centerY)
            make.centerX.equalTo(relative.snp.centerX)
            make.height.width.equalTo(55)
        }
        
    }
}
