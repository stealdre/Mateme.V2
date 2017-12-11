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
    
    var containerView = UIView()
    
    var registerLabel = UILabel()
	
	var pseudo = SkyFloatingLabelTextField()
	var phoneNumber = SkyFloatingLabelTextField()
	var emailField = SkyFloatingLabelTextField()
	var passwordField = SkyFloatingLabelTextField()
	var confirmPasswordField = SkyFloatingLabelTextField()
    
	var registerButton = RegisterButton()
    
    var backButton = BackButton()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        view.backgroundColor = .white
        
		self.hideKeyboard()
        
        registerLabel.font = UIFont(name: "Roboto-Regular", size: 32)
        registerLabel.text = "Register"
        registerLabel.textColor = .black
        
		pseudo.title = "Pseudo"
        pseudo.selectedTitleColor = .black
        pseudo.placeholder = "Pseudo"
        pseudo.selectedLineColor = .black
        pseudo.lineColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        phoneNumber.title = "Phone Number"
        phoneNumber.selectedTitleColor = .black
        phoneNumber.placeholder = "Phone Number"
        phoneNumber.selectedLineColor = .black
        phoneNumber.lineColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        
        emailField.title = "Email"
        emailField.selectedTitleColor = .black
        emailField.placeholder = "Email"
        emailField.selectedLineColor = .black
        emailField.lineColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
		emailField.autocapitalizationType = .none
        
		passwordField.title = "Password"
        passwordField.selectedTitleColor = .black
        passwordField.placeholder = "Password"
        passwordField.selectedLineColor = .black
        passwordField.lineColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        passwordField.isSecureTextEntry = true
        
        confirmPasswordField.title = "Confirm Password"
        confirmPasswordField.selectedTitleColor = .black
		confirmPasswordField.placeholder = "Confirm Password"
        confirmPasswordField.selectedLineColor = .black
        confirmPasswordField.lineColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        confirmPasswordField.isSecureTextEntry = true
        
		registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
		registerButton.backgroundColor = .clear
		registerButton.addTarget(self, action: #selector(createAccountAction), for: .touchUpInside)
		
        backButton.backgroundColor = .black
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        backButton.setBackgroundImage(UIImage(named: "closeRegister_ic"), for: .normal)
        
        view.addSubview(containerView)
        containerView.addSubview(registerLabel)
		containerView.addSubview(pseudo)
		containerView.addSubview(phoneNumber)
		containerView.addSubview(emailField)
		containerView.addSubview(passwordField)
		containerView.addSubview(confirmPasswordField)
		containerView.addSubview(registerButton)
		containerView.addSubview(backButton)
        
		view.setNeedsUpdateConstraints()
		
		ref = Database.database().reference()

    }

    
    @objc func didTapBack() {
        
        dismiss(animated: true, completion: nil)
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
					
					registerUser(userID: (user?.uid)!)
					
				} else {
					let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
					
					let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
					alertController.addAction(defaultAction)
					
					self.present(alertController, animated: true, completion: nil)
				}
			}
		}
		
		func registerUser(userID: String) {
            let newRef = self.ref.child("users/\(userID)")
			newRef.child("name").setValue(pseudo.text)
			newRef.child("phoneNumber").setValue(phoneNumber.text)
			newRef.child("profilePicPath").setValue("usersProfilePic/default.jpg")
            newRef.child("rate").setValue(0.0)
            newRef.child("bio").setValue("")
			
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
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.center.equalTo(view.snp.center)
        }
        registerLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.6)
            make.height.equalTo(50)
            make.left.equalTo(containerView.snp.left).offset(35)
            make.top.equalTo(containerView.snp.top).offset(30)
        }
		pseudo.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(containerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(50)
			make.left.equalTo(containerView.snp.left).offset(35)
			make.top.equalTo(registerLabel.snp.bottom).offset(10)
		}
		phoneNumber.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(containerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(50)
			make.left.equalTo(containerView.snp.left).offset(35)
			make.top.equalTo(pseudo.snp.bottom).offset(20)
		}
		emailField.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(containerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(50)
			make.left.equalTo(containerView.snp.left).offset(35)
			make.top.equalTo(phoneNumber.snp.bottom).offset(20)
		}
		passwordField.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(containerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(50)
			make.left.equalTo(containerView.snp.left).offset(35)
			make.top.equalTo(emailField.snp.bottom).offset(20)
		}
		confirmPasswordField.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(containerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(50)
			make.left.equalTo(containerView.snp.left).offset(35)
			make.top.equalTo(passwordField.snp.bottom).offset(20)
		}
        registerButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.5)
            make.height.equalTo(50)
            make.centerX.equalTo(containerView.snp.centerX)
            make.top.equalTo(confirmPasswordField.snp.bottom).offset(50)
        }
        backButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(70)
            make.height.equalTo(70)
            make.centerX.equalTo(containerView.snp.centerX)
            make.bottom.equalTo(containerView.snp.bottom).offset(-35)
        }
		super.updateViewConstraints()
	}
}

class RegisterButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
}

class BackButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2
    }
}

extension RegisterViewController {
    
	func hideKeyboard() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(RegisterViewController.dismissKeyboard))
		
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}
