//
//  SearchGameSearchBar.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 17/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShowsCancelButton(false, animated: false)
    }
}
