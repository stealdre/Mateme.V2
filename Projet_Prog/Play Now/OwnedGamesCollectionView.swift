//
//  OwnedGamesCollectionView.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 15/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class OwnedGamesCollectionView: UICollectionView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.itemSize = CGSize(width: 85*2 , height: 85*2)
        super.init(frame: CGRect(), collectionViewLayout: layout)
        
        commonInit()
    }
    
    func commonInit() {
        
        allowsMultipleSelection = false
        backgroundColor = .clear
        contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        frame = UIScreen.main.bounds
        
        self.register(OwnedGameUICollectionViewCell.self, forCellWithReuseIdentifier: "OGCell")
        
        
    }

}
