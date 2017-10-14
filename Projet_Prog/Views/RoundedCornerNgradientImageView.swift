//
//  RoundedCornerNgradientImageView.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 14/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class RoundedCornerNgradientImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addCornerRadiusTop()
        self.addgradient()
        
    }
    
    func addCornerRadiusTop() {
        let maskLayer = CAShapeLayer()
        
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.topLeft, .topRight],
                                cornerRadii: CGSize(width: 10, height:  10))
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
    }
    
    func addgradient() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.7).cgColor]
        gradientLayer.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.height / 2, width: self.frame.width, height: self.frame.height / 2)
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale;
        
        self.layer.addSublayer(gradientLayer)
    }
}
