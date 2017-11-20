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
	
	var emailField = UITextField()
	var passwordField = UITextField()
	var signInButton = UIButton()
	var registerButton = UIButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        emailField.autocapitalizationType = .none
		emailField.placeholder = "Email here"
        
		passwordField.placeholder = "Password here"
        passwordField.autocapitalizationType = .none
        passwordField.isSecureTextEntry = true
        
		signInButton.setTitle("Signe In", for: .normal)
		signInButton.backgroundColor = .black
		registerButton.setTitle("Register", for: .normal)
		registerButton.backgroundColor = .black
		
		signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
		registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
		
		
		view.addSubview(emailField)
		view.addSubview(passwordField)
		view.addSubview(signInButton)
		view.addSubview(registerButton)
		
		
		view.setNeedsUpdateConstraints()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		if let _ = Auth.auth().currentUser {
			//self.signIn()
		}
	}
	
	@objc func didTapSignIn() {
		let email = emailField.text
		let password = passwordField.text
		Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
			guard let _ = user else {
				if let error = error {
					if let errCode = AuthErrorCode(rawValue: error._code) {
						switch errCode {
						case .userNotFound:
							self.showAlert("User account not found. Try registering")
						case .wrongPassword:
							self.showAlert("Incorrect username/password combination")
						default:
							self.showAlert("Error: \(error.localizedDescription)")
						}
					}
					return
				}
				assertionFailure("user and error are nil")
				return
			}
			
			self.signIn()
		})
	}
	
	@objc func didTapRegister() {
		present(RegisterViewController(), animated: true, completion: nil)
	}
	
	func didRequestPasswordReset() {
		let prompt = UIAlertController(title: "To Do App", message: "Email:", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
			let userInput = prompt.textFields![0].text
			if (userInput!.isEmpty) {
				return
			}
			Auth.auth().sendPasswordReset(withEmail: userInput!, completion: { (error) in
				if let error = error {
					if let errCode = AuthErrorCode(rawValue: error._code) {
						switch errCode {
						case .userNotFound:
							DispatchQueue.main.async {
								self.showAlert("User account not found. Try registering")
							}
						default:
							DispatchQueue.main.async {
								self.showAlert("Error: \(error.localizedDescription)")
							}
						}
					}
					return
				} else {
					DispatchQueue.main.async {
						self.showAlert("You'll receive an email shortly to reset your password.")
					}
				}
			})
		}
		prompt.addTextField(configurationHandler: nil)
		prompt.addAction(okAction)
		present(prompt, animated: true, completion: nil)
	}
	
	func showAlert(_ message: String) {
		let alertController = UIAlertController(title: "Oupss", message: message, preferredStyle: UIAlertControllerStyle.alert)
		alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
		self.present(alertController, animated: true, completion: nil)
	}
	
	func signIn() {
		present(MenuViewController(), animated: true, completion: nil)
	}
	
}

extension LoginViewController {
	
	override func updateViewConstraints() {
		emailField.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(view.snp.centerY).offset(-70)
		}
		passwordField.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(emailField.snp.bottom).offset(20)
		}
		signInButton.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(passwordField.snp.bottom).offset(30)
		}
		registerButton.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(signInButton.snp.bottom).offset(30)
		}
		super.updateViewConstraints()
	}
}
