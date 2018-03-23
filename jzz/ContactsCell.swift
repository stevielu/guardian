//
//  ContactsCell.swift
//  jzz
//
//  Created by wei lu on 16/04/17.
//  Copyright © 2017 totalapps. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ContactsCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.size.width = globalStyle.screenSize.width-12.5
            super.frame = frame
        }
    }
    
    
    var cellTitle:UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = globalStyle.titleFont
        nameLabel.textColor = globalStyle.titleColor
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    
    var avatar:UIImageView = {
        let avatar = UIImageView()
        avatar.layer.cornerRadius = 6
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.layer.masksToBounds = false
        avatar.clipsToBounds = true
        return avatar
    }()
    
    override init(style:UITableViewCellStyle,reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemneted")
    }
    
    
    func setupViews(){
        addSubview(cellTitle)
        addSubview(avatar)
        
        self.cellTitle.snp.makeConstraints{(make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(avatar.snp.right).offset(25)
            make.width.equalTo(self.bounds.width - 25)
            //make.right.equalTo(self.budget.snp_left).offset(-12.5)
        }
        
        self.avatar.snp.makeConstraints{(make) in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).offset(25)
            make.height.width.equalTo(35)
            //make.edges.equalTo(self).inset(UIEdgeInsets(top: 5, left: 25, bottom: 5, right: globalStyle.screenSize.width-37.5-25-45))
        }
        
        
    }
}
