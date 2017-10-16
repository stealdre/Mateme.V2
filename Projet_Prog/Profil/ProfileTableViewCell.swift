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
    var gameDate = UILabel()
    
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
        
        contentView.addSubview(gamePic)
        
        gamePic.image = UIImage(named: "profilPic")
        gamePic.contentMode = .scaleAspectFill
        
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
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}
