//
//  Games.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 14/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import FirebaseDatabase


class Games {
    
    var name: String = ""
    var type: String = ""
    var image: UIImage = UIImage()
    var description: String = ""

    var ref: DatabaseReference?
    
    init (snapshot: DataSnapshot) {
        
        ref = snapshot.ref
        
        let data = snapshot.value as! [String : Any]
        
        name = data["name"]! as! String
        type = data["type"]! as! String
        description = data["description"]! as! String
    }
    
    
}


