//
//  ProfileTableViewCell.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 16/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import Cosmos

class ProfileTableViewCell: UITableViewCell {
    
    var didSetupConstraints = false
    
    var mateName = UILabel()
	var gameName = UILabel()
    var sessionDate = UILabel()
    
    var gamePic = RoundImageView()
	
	var stars = ratingStars()
    
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
		mateName.textColor = UIColor(red:1, green:1, blue:1, alpha:1)
		
		gameName.font = UIFont(name: "Roboto-Regular", size: 15)
		gameName.textColor = UIColor(red:0.45, green:0.45, blue:0.45, alpha:1.0)
		
		sessionDate.font = UIFont(name: "Roboto-Light", size: 13)
		sessionDate.textColor = UIColor(red:1, green:1, blue:1, alpha:0.6)
		
		sessionDate.textAlignment = .right
		
		contentView.backgroundColor = .clear
		
		contentView.addSubview(gamePic)
		contentView.addSubview(mateName)
		contentView.addSubview(gameName)
		contentView.addSubview(sessionDate)
		contentView.addSubview(stars)

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
			sessionDate.snp.makeConstraints { (make) -> Void in
				make.width.equalTo(contentView.snp.width).multipliedBy(0.7)
				make.height.equalTo(30)
				make.right.equalTo(contentView.snp.right).inset(20)
				make.bottom.equalTo(contentView.snp.bottom).inset(5)
			}
			stars.snp.makeConstraints { (make) -> Void in
				make.width.equalTo(contentView.snp.width).multipliedBy(0.3)
				make.height.equalTo(30)
				make.right.equalTo(contentView.snp.right).inset(20)
				make.bottom.equalTo(contentView.snp.bottom).inset(33)
			}
			
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}

class ratingStars: CosmosView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)

		self.rating = 3
		self.settings.fillMode = .full
		
		// Set the color of a filled star
		self.settings.filledColor = UIColor.white
		
		// Set the border color of an empty star
		self.settings.emptyBorderColor = UIColor.white
		
		// Set the border color of a filled star
		self.settings.filledBorderColor = UIColor.white
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
