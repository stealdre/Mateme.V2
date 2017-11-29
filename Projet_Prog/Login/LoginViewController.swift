//
//  LoginViewController.swift
//  Projet_Prog
//
//  Created by Maxence on 08/11/2017.
//  Copyright © 2017 Hemispher. All rights reserved.
//
import UIKit
import FirebaseAuth
import BubbleTransition
import SkyFloatingLabelTextField

class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    let transition = BubbleTransition()
	
	var emailField = SkyFloatingLabelTextFieldWithIcon()
	var passwordField = SkyFloatingLabelTextFieldWithIcon()
	var signInButton = LoginButton()
	var registerButton = roundButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        emailField.autocapitalizationType = .none
        emailField.title = "Email"
        emailField.selectedTitleColor = .black
		emailField.placeholder = "Email"
        
		passwordField.placeholder = "Password"
        passwordField.title = "Password"
        passwordField.selectedTitleColor = .black
        passwordField.autocapitalizationType = .none
        passwordField.isSecureTextEntry = true
        
		signInButton.setTitle("Login", for: .normal)
        signInButton.backgroundColor = .clear
        signInButton.setTitleColor(.black, for: .normal)
        
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
			self.signIn()
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
        let controller = RegisterViewController()
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        
        present(controller, animated: true, completion: nil)
	}
    
    // MARK: UIViewControllerTransitioningDelegate
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = registerButton.center
        transition.bubbleColor = registerButton.backgroundColor!
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = registerButton.center
        transition.bubbleColor = registerButton.backgroundColor!
        return transition
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
			make.width.equalTo(100)
			make.height.equalTo(100)
			make.centerX.equalTo(view.snp.centerX)
			make.top.equalTo(signInButton.snp.bottom).offset(30)
		}
		super.updateViewConstraints()
	}
}

class LoginButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        
    }
}
