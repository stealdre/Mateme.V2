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
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController {

	var ref: DatabaseReference!
	var user: User!
	
	var pseudo = SkyFloatingLabelTextFieldWithIcon()
	var phoneNumber = SkyFloatingLabelTextFieldWithIcon()
	var emailField = SkyFloatingLabelTextFieldWithIcon()
	var passwordField = SkyFloatingLabelTextFieldWithIcon()
	var confirmPasswordField = SkyFloatingLabelTextFieldWithIcon()
    
	var registerButton = RegisterButton()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        view.backgroundColor = .black
		
		pseudo.placeholder = "Pseudo"
        pseudo.selectedTitleColor = .white
        pseudo.placeholder = "Pseudo"
        pseudo.selectedLineColor = .white
        pseudo.lineColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        
        phoneNumber.placeholder = "Phone Number"
        phoneNumber.selectedTitleColor = .white
        phoneNumber.placeholder = "Phone Number"
        phoneNumber.selectedLineColor = .white
        phoneNumber.lineColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        
        emailField.placeholder = "Email"
        emailField.selectedTitleColor = .white
        emailField.placeholder = "Email"
        emailField.selectedLineColor = .white
        emailField.lineColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        
		passwordField.placeholder = "Password"
        passwordField.selectedTitleColor = .white
        passwordField.placeholder = "Password"
        passwordField.selectedLineColor = .white
        passwordField.lineColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        
        confirmPasswordField.title = "Confirm Password"
        confirmPasswordField.selectedTitleColor = .white
		confirmPasswordField.placeholder = "Confirm Password"
        confirmPasswordField.selectedLineColor = .white
        confirmPasswordField.lineColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        
		registerButton.setTitle("Register", for: .normal)
		registerButton.backgroundColor = .clear
        registerButton.setTitleColor(.white, for: .normal)
		
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
class roundButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
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
			make.height.equalTo(100)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(confirmPasswordField.snp.bottom).offset(50)
		}
		super.updateViewConstraints()
	}
}

class RegisterButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
}
