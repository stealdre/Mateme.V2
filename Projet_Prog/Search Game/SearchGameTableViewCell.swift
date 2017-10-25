//
//  SearchGameTableViewCell.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 19/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class SearchGameTableViewCell: UITableViewCell {
    
    let queue = SerialOperationQueue()
    
    var gameImage = roundedCornerImageView()
    var gameNameLabel = UILabel()
    var gameTypeLabel = UILabel()
    var ownedGameIndicatorView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareForReuse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gameImage.contentMode = .scaleAspectFill
        
        gameNameLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        gameNameLabel.textColor = .white
        
        gameTypeLabel.font = UIFont(name: "Roboto-Bold", size: 15)
        gameTypeLabel.textColor = UIColor(red:1, green:1, blue:1, alpha:0.5)
        

        contentView.addSubview(gameImage)
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(gameTypeLabel)
        contentView.addSubview(ownedGameIndicatorView)
        
        contentView.setNeedsUpdateConstraints()        
    }

    override func updateConstraints() {
        
        gameImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.contentView.snp.height).multipliedBy(0.7)
            make.height.equalTo(gameImage.snp.width)
            make.left.equalTo(self.contentView.snp.left).offset(10)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        gameNameLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.contentView.snp.width)
            make.height.equalTo(30)
            make.left.equalTo(gameImage.snp.right).offset(15)
            make.top.equalTo(contentView.snp.top).offset(27)
        }
        gameTypeLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.contentView.snp.width)
            make.height.equalTo(30)
            make.left.equalTo(gameImage.snp.right).offset(15)
            make.bottom.equalTo(self.contentView.snp.bottom).inset(27)
        }
        ownedGameIndicatorView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(5)
            make.height.equalTo(self.contentView.snp.height)
            make.left.equalTo(self.contentView.snp.left)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        
        super.updateConstraints()
    }

}

class SerialOperationQueue: OperationQueue {
    override init() {
        super.init()
        maxConcurrentOperationCount = 1
    }
}
