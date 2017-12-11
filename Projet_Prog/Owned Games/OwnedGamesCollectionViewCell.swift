//
//  OwnedGameUICollectionViewCell.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 15/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class OwnedGamesCollectionViewCell: UICollectionViewCell {
    
    let queue = SerialOperationQueue()
    
    let gameImage = UIImageView()
    let gameNameLabel = UILabel()
    let gameTypeLabel = UILabel()
    let playButton = UIButton()
    let favoriteGameLabel = UILabel()

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareForReuse()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.backgroundColor = .white
        
        gameImage.backgroundColor = .clear
        gameImage.clipsToBounds = true
        gameImage.contentMode = .scaleAspectFill
        gameImage.layer.cornerRadius = 10
        
        favoriteGameLabel.text = "OWNED"
        favoriteGameLabel.font = UIFont(name: "Roboto-Medium", size: 10)
        favoriteGameLabel.textColor = UIColor(red:0.07, green:0.47, blue:0.79, alpha:1.0)
        
        gameNameLabel.text = "League of Legends"
        gameNameLabel.font = UIFont(name: "Roboto-Bold", size: 18)
        gameNameLabel.textColor = .darkGray
        
        gameTypeLabel.text = "MOBA"
        gameTypeLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        gameTypeLabel.textColor = .gray
        
        playButton.setBackgroundImage(UIImage(named: "supp_ic"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonAction(sender:)), for: .touchUpInside)
        
        contentView.addSubview(gameImage)
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(gameTypeLabel)
        contentView.addSubview(favoriteGameLabel)
        contentView.addSubview(playButton)

        updateConstraints()
    }
    
     override func layoutSubviews() {
        super.layoutSubviews()
        
        playButton.layer.cornerRadius = playButton.frame.width / 2
        playButton.clipsToBounds = true
    }
    
    @objc func playButtonAction(sender: UIButton!) {
        
    }
}

// MARK: Constraints
extension OwnedGamesCollectionViewCell {
    
    override func updateConstraints() {
        
        gameImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.73)
            make.top.equalTo(contentView.snp.top)
            make.right.equalTo(contentView.snp.right)
        }
        favoriteGameLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(contentView.snp.width).multipliedBy(0.4)
            make.height.equalTo(13)
            make.top.equalTo(gameImage.snp.bottom).offset(5)
            make.left.equalTo(contentView.snp.left).offset(10)
        }
        gameNameLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(contentView.snp.width).multipliedBy(0.9)
            make.height.equalTo(19)
            make.top.equalTo(favoriteGameLabel.snp.bottom).offset(7)
            make.left.equalTo(favoriteGameLabel.snp.left)
        }
        gameTypeLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(contentView.snp.width).multipliedBy(0.5)
            make.height.equalTo(14)
            make.top.equalTo(gameNameLabel.snp.bottom).offset(2)
            make.left.equalTo(gameNameLabel.snp.left)
        }
        playButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(playButton.snp.width)
            make.centerY.equalTo(gameImage.snp.bottom)
            make.right.equalTo(contentView.snp.right).inset(30)
        }
        
        super.updateConstraints()
    }

}
