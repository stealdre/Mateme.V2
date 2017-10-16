//
//  ProfileTableViewCell.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 16/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    var didSetupConstraints = false
    
    var mateName = UILabel()
	var gameName = UILabel()
    var sessionDate = UILabel()
    
    var gamePic = RoundImageView()
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gamePic.image = UIImage(named: "profilPic")
        gamePic.contentMode = .scaleAspectFill
		
		mateName.font = UIFont(name: "Roboto-Regular", size: 20)
		
		gameName.font = UIFont(name: "Roboto-Light", size: 15)
		gameName.textColor = UIColor(red:0.45, green:0.45, blue:0.45, alpha:1.0)
		
		
		contentView.addSubview(gamePic)
		contentView.addSubview(mateName)
		contentView.addSubview(gameName)
		
        contentView.setNeedsUpdateConstraints()
    }
    
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            gamePic.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(60)
                make.height.equalTo(60)
                make.leftMargin.equalTo(15)
                make.centerY.equalTo(contentView.snp.centerY)
            }
			mateName.snp.makeConstraints { (make) -> Void in
				make.width.equalTo(contentView.snp.width).multipliedBy(0.7)
				make.height.equalTo(30)
				make.left.equalTo(gamePic.snp.right).offset(20)
				make.top.equalTo(contentView.snp.top).inset(10)
			}
			gameName.snp.makeConstraints { (make) -> Void in
				make.width.equalTo(contentView.snp.width).multipliedBy(0.7)
				make.height.equalTo(30)
				make.left.equalTo(gamePic.snp.right).offset(20)
				make.bottom.equalTo(contentView.snp.bottom).inset(10)
			}
			
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}
