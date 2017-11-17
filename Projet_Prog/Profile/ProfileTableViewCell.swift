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
    
    var containerView = UIView()
    
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
        
        containerView.backgroundColor = .white
        
		//gamePic.image = UIImage(named: "profilPic")
        gamePic.contentMode = .scaleAspectFill
        
        mateName.font = UIFont(name: "Roboto-Regular", size: 20)
        mateName.textColor = .black
        
        gameName.font = UIFont(name: "Roboto-Regular", size: 15)
        gameName.textColor = .black
        gameName.alpha = 0.7
        
        sessionDate.font = UIFont(name: "Roboto-Light", size: 13)
        sessionDate.textColor = .black
        sessionDate.alpha = 0.6
        
        sessionDate.textAlignment = .right
        
        contentView.addSubview(containerView)
        containerView.addSubview(gamePic)
        containerView.addSubview(mateName)
        containerView.addSubview(gameName)
        containerView.addSubview(sessionDate)
        containerView.addSubview(stars)
        
        contentView.setNeedsUpdateConstraints()
    }
    
    
    override func updateConstraints() {
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(contentView.snp.width).multipliedBy(0.95)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.9)
            make.center.equalTo(contentView.snp.center)
        }
        gamePic.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.leftMargin.equalTo(15)
            make.centerY.equalTo(containerView.snp.centerY)
        }
        mateName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.7)
            make.height.equalTo(30)
            make.left.equalTo(gamePic.snp.right).offset(20)
            make.top.equalTo(containerView.snp.top).inset(7)
        }
        gameName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.7)
            make.height.equalTo(30)
            make.left.equalTo(gamePic.snp.right).offset(20)
            make.bottom.equalTo(containerView.snp.bottom).inset(10)
        }
        sessionDate.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.7)
            make.height.equalTo(30)
            make.right.equalTo(containerView.snp.right).offset(-17)
            make.bottom.equalTo(containerView.snp.bottom).inset(5)
        }
        stars.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.3)
            make.height.equalTo(30)
            make.right.equalTo(containerView.snp.right).offset(-23)
            make.centerY.equalTo(mateName.snp.centerY).offset(4)
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
        self.settings.filledColor = .black
        
        // Set the border color of an empty star
        self.settings.emptyBorderColor = .black
        
        // Set the border color of a filled star
        self.settings.filledBorderColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
