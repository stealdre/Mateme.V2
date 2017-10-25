//
//  ShadowNCornerRadiusView.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 14/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class ShadowNCornerRadiusView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cornerRadius = CGFloat(10)
        
        self.layer.cornerRadius = cornerRadius
        
        self.addShadow(offset: CGSize(width: 0, height: 18.0), color: UIColor.black, radius: 15, opacity: 0.1)
        
    }
}

class ShadowView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadow(offset: CGSize(width: 0, height: 10), color: UIColor.black, radius: 10, opacity: 0.05)
        
        self.backgroundColor = .white
        
    }
}

class BGGradientView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red:1, green:1, blue:1, alpha:0.025).cgColor, UIColor.black.cgColor]
        gradientLayer.frame = self.frame
        gradientLayer.locations = [0.0, 1.0]
        
//        self.layer.shouldRasterize = true
//        self.layer.rasterizationScale = UIScreen.main.scale
        
        self.layer.addSublayer(gradientLayer)
    }
}

class PlayNowButtonView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .white
        self.alpha = 0.1
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
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
