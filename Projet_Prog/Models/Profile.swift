//
//  Profile.swift
//  Projet_Prog
//
//  Created by Maxence on 14/11/2017.
//  Copyright © 2017 Hemispher. All rights reserved.
//

import UIKit
import FirebaseDatabase


class Profile {
	
	var name: String = ""
	var profilPicPath: String = ""
	
	struct History {
		
		var gameDate: String = ""
		var gameID: String = ""
		var gameName: String = ""
		var mateID: String = ""
		var mateName: String = ""
		var rate: Float = 0.0
	}
	
	var historiesArray = [History]()

	var ref: DatabaseReference?
	
	init (snapshot: DataSnapshot) {
		
		ref = snapshot.ref
		
		let data = snapshot.value as! [String: Any]

		print(data)
		
		name = data["name"]! as! String
		profilPicPath = data["profilePicPath"]! as! String
		
		if let H = data["history"] {
			
			let histories = data["history"] as! [String : [String: Any]]

			for history in histories {
				var item = History()
				let array = history.value
				
				item.gameDate = history.key
				item.gameID = array["gameID"] as! String
				item.mateID = array["mateID"] as! String
				item.rate = array["rate"] as! Float
				
				historiesArray.append(item)
			}
		}
		//print(histories)
	}
	
	
}
