//
//  LoginViewController.swift
//  Projet_Prog
//
//  Created by Maxence on 08/11/2017.
//  Copyright © 2017 Hemispher. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let emailField = UITextField()
    let passwordField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
	}
    
    
    func signUp() {
        
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            // ...
        }
    }
    
    func signIn() {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            // ...
        }

    }

}

extension LoginViewController {
    
    override func updateViewConstraints() {
        
        
        super.updateViewConstraints()
    }
}
