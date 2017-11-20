//
//  RegisterViewController.swift
//  Projet_Prog
//
//  Created by Maxence on 20/11/2017.
//  Copyright © 2017 Hemispher. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterViewController: UIViewController {

	var ref: DatabaseReference!
	var user: User!
	
	var pseudo = UITextField()
	var phoneNumber = UITextField()
	var emailField = UITextField()
	var passwordField = UITextField()
	var confirmPasswordField = UITextField()
	var registerButton = UIButton()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		pseudo.placeholder = "Pseudo here"
		phoneNumber.placeholder = "Phone number here (Facetime)"
		emailField.placeholder = "Email here"
		passwordField.placeholder = "Password here"
		confirmPasswordField.placeholder = "Confirm password here"
		registerButton.setTitle("Register", for: .normal)
		registerButton.backgroundColor = .black
		
		registerButton.addTarget(self, action: #selector(createAccountAction), for: .touchUpInside)
		
		view.addSubview(pseudo)
		view.addSubview(phoneNumber)
		view.addSubview(emailField)
		view.addSubview(passwordField)
		view.addSubview(confirmPasswordField)
		view.addSubview(registerButton)
		
		view.setNeedsUpdateConstraints()
		
		ref = Database.database().reference()
		user = Auth.auth().currentUser
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@objc func createAccountAction() {
		
		if emailField.text == "" || pseudo.text == "" || phoneNumber.text == "" {
			let alertController = UIAlertController(title: "Error", message: "Please complete informations", preferredStyle: .alert)
			
			let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			
			present(alertController, animated: true, completion: nil)
			
		}
		else if passwordField.text != confirmPasswordField.text {
			let alertController = UIAlertController(title: "Error", message: "Different password", preferredStyle: .alert)
			
			let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			alertController.addAction(defaultAction)
			
			present(alertController, animated: true, completion: nil)
		}
		else {
			Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
				
				if error == nil {
					print("You have successfully signed up")
					//Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
					
					//let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
					//self.present(vc!, animated: true, completion: nil)
					
					registerUser()
					
				} else {
					let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
					
					let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
					alertController.addAction(defaultAction)
					
					self.present(alertController, animated: true, completion: nil)
				}
			}
		}
		
		func registerUser() {

			self.ref.child("users/\(user.uid)/name").setValue(pseudo.text)
			self.ref.child("users/\(user.uid)/phoneNumber").setValue(phoneNumber.text)
			
			self.present(MenuViewController(), animated: true, completion: nil)
		}
	}

}

extension RegisterViewController {
	
	override func updateViewConstraints() {
		pseudo.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(view.snp.centerY)
		}
		phoneNumber.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(pseudo.snp.bottom).offset(20)
		}
		emailField.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(phoneNumber.snp.bottom).offset(20)
		}
		passwordField.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(emailField.snp.bottom).offset(20)
		}
		confirmPasswordField.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(passwordField.snp.bottom).offset(20)
		}
		registerButton.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(confirmPasswordField.snp.bottom).offset(30)
		}
		super.updateViewConstraints()
	}
}
