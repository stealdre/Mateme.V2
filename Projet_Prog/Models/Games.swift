//
//  Games.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 14/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

struct Games {
    
    let name: String
    let type: String
    let image: UIImage
    let description: String
    
}

// MARK: Replace with Firebase request
func allGames() -> [Games] {
    
    var games = [Games]()
    
    var imagesName = [String]()
    
    for _ in 0..<30 {
        imagesName.append("\(arc4random_uniform(33))")
    }
    
    for i in 0..<20 {
        
        games.append(Games(name: "LEAGUE OF LEGENDS \(i)", type: "MOBA", image: UIImage(named: "\(imagesName[i])")!, description: "League of Legends est un jeu vidéo de type arène de bataille en ligne gratuit développé et édité par Riot Games sur Windows et Mac OS X. Fin janvier 2013, un nouveau client bêta pour Mac a été distribué par Riot Games."))
    }
    
    return games
}



