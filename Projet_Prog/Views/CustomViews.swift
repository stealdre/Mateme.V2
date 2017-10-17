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
