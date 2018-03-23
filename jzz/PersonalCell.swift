//
//  PersonalCell.swift
//  jzz
//
//  Created by wei lu on 24/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class PersonalCell: SettingCell {
    var cellValue:UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = globalStyle.titleFont
        nameLabel.textColor = globalStyle.titleColor
        nameLabel.textAlignment = .right
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    override func setupViews(){
        addSubview(cellValue)
        addSubview(cellTitle)
        
        
        self.cellTitle.snp.makeConstraints{(make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).offset(25)
            make.width.equalTo(75)
        }
        
        self.cellValue.snp.makeConstraints{(make) in
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(self.snp.right).offset(-30)
            make.left.equalTo(cellTitle.snp.right).offset(35)
            //make.right.equalTo(self.budget.snp_left).offset(-12.5)
        }
        
    }
}
