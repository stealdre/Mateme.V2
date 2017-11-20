//
//  SettingsTheme.swift
//  StarWarsAnimations
//
//  Created by Artem Sidorenko on 10/5/15.
//  Copyright © 2015 Yalantis. All rights reserved.
//

import UIKit

class SettingsTheme {
    
    static var light: SettingsTheme {
        return SettingsTheme(dark: false)
    }
    
    static var dark: SettingsTheme {
        return SettingsTheme(dark: true)
    }

    let backgroundColor: UIColor
    let separatorColor: UIColor
    let topImage: UIImage
    
    let title: String
    
    init(dark: Bool) {
        if dark {
            title = "Login"
            backgroundColor = UIColor.white
            separatorColor = UIColor.black
            topImage = UIImage(named: "gamepad_ic")!
        } else {
            title = "Register"
            backgroundColor = UIColor.black
            separatorColor = UIColor.white
            topImage = UIImage(named: "gamepad_ic")!
        }
    }
}
