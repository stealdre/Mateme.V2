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
	
    var containerView = UIView()
    
    var logo = UIImageView()
    
    var loginLabel = UILabel()
    
	var emailField = SkyFloatingLabelTextField()
	var passwordField = SkyFloatingLabelTextField()
	var signInButton = LoginButton()
	var registerButton = BackButton()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            self.signIn()
        }
        
        view.backgroundColor = .black
        containerView.backgroundColor = .clear
        
        self.hideKeyboard()
        
        logo.image = UIImage(named: "app logo")
        
        loginLabel.font = UIFont(name: "Roboto-Regular", size: 32)
        loginLabel.text = "LOGIN"
        loginLabel.textColor = .white
		
        emailField.autocapitalizationType = .none
        emailField.title = "Email"
        emailField.selectedTitleColor = .white
        emailField.selectedLineColor = .white
		emailField.placeholder = "Email"
        emailField.textColor = .white
        
		passwordField.placeholder = "Password"
        passwordField.title = "Password"
        passwordField.selectedTitleColor = .white
        passwordField.selectedLineColor = .white
        passwordField.textColor = .white
        passwordField.autocapitalizationType = .none
        passwordField.isSecureTextEntry = true
        
		signInButton.setTitle("Login", for: .normal)
        signInButton.backgroundColor = .clear
        signInButton.setTitleColor(.white, for: .normal)
        
        registerButton.setBackgroundImage(UIImage(named: "register_ic"), for: .normal)
		registerButton.backgroundColor = .white
		
		signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
		registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
		
		
        view.addSubview(containerView)
        containerView.addSubview(logo)
        containerView.addSubview(loginLabel)
		containerView.addSubview(emailField)
		containerView.addSubview(passwordField)
		containerView.addSubview(signInButton)
		containerView.addSubview(registerButton)
		
		
		view.setNeedsUpdateConstraints()
        
        transition.duration = 0.3
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
        
        present(controller, animated: true, completion: { () -> Void in
        })
        
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
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.center.equalTo(view.snp.center)
        }
        logo.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(65)
            make.centerX.equalTo(containerView.snp.centerX)
            make.top.equalTo(containerView.snp.top).offset(60)
        }
        loginLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.6)
            make.height.equalTo(50)
            make.left.equalTo(containerView.snp.left).offset(35)
            make.top.equalTo(logo.snp.bottom).offset(40)
        }
		emailField.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(containerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(50)
			make.left.equalTo(containerView.snp.left).offset(35)
			make.top.equalTo(loginLabel.snp.bottom).offset(10)
		}
		passwordField.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(containerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(50)
			make.left.equalTo(containerView.snp.left).offset(35)
			make.top.equalTo(emailField.snp.bottom).offset(20)
		}
		signInButton.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(containerView.snp.width).multipliedBy(0.5)
			make.height.equalTo(50)
			make.centerX.equalTo(containerView.snp.centerX)
			make.top.equalTo(passwordField.snp.bottom).offset(50)
		}
        registerButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(70)
            make.height.equalTo(70)
            make.centerX.equalTo(containerView.snp.centerX)
            make.bottom.equalTo(containerView.snp.bottom).offset(-35)
        }
		super.updateViewConstraints()
	}
}

extension LoginViewController {
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(LoginViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class LoginButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        
    }
}
