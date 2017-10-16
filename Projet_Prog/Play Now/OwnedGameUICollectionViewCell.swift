//
//  OwnedGameUICollectionViewCell.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 15/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit


class OwnedGameUICollectionViewCell: UICollectionViewCell {
    
    var didSetupConstraints = false
    
    let queue = SerialOperationQueue()
    
    let shadowEffectView = UIView()
    
    let gameImage = GradientImageView()

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareForReuse()
    }
    
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        self.contentView.backgroundColor = .clear
        
        gameImage.backgroundColor = .clear
        gameImage.clipsToBounds = true
        gameImage.contentMode = .scaleAspectFill
        gameImage.layer.cornerRadius = 10
        
        shadowEffectView.backgroundColor = .white
        shadowEffectView.layer.cornerRadius = 10
        shadowEffectView.addShadow(offset: CGSize(width: 0, height: 3), color: UIColor.black, radius: 14, opacity: 0.1)
        
        contentView.addSubview(shadowEffectView)
        self.contentView.addSubview(gameImage)

        self.updateConstraints()
        
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            gameImage.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(self.contentView.snp.width)
                make.height.equalTo(self.contentView.snp.height)
                make.top.equalTo(self.contentView.snp.top)
                make.right.equalTo(self.contentView.snp.right)
            }
            
            shadowEffectView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(self.contentView.snp.width)
                make.height.equalTo(self.contentView.snp.height)
                make.top.equalTo(self.contentView.snp.top)
                make.right.equalTo(self.contentView.snp.right)
            }
            
            didSetupConstraints = true
            
        }
        super.updateConstraints()
    }
}

class SerialOperationQueue: OperationQueue
{
    override init()
    {
        super.init()
        maxConcurrentOperationCount = 1
    }
}

extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        //Optional, to improve performance:
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        layer.shouldRasterize = true
        
        let backgroundCGColor = self.backgroundColor?.cgColor
        self.backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}
