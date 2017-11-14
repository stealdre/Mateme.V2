//
//  PlayNowViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 22/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import CircleMenu
import SwiftSpinner
import FirebaseDatabase
import FirebaseAuth


class PlayNowViewController: UIViewController, CircleMenuDelegate {
    
    var user: User!
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    let buttonView = PlayNowButtonView()
    
    let buttonViewIcon = UIImageView()
    
    var button: CircleMenu! = nil
    
    let infoLabel = UILabel()
    
    let gameImage = UIImageView()
    
    let spinnerLoadingView = SpinnerView()
    
    var tapToDismissView = UIView()
    var tapToDismisslabel = UILabel()
    
    var canAnimateButton = true
    var animatingButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameImage.isHidden = true
        gameImage.alpha = 0
        gameImage.image = UIImage(named: "35")
        gameImage.contentMode = .scaleAspectFill
        
        infoLabel.text = "Touch to find a mate"
        infoLabel.textColor = .white
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont(name: "Roboto-Bold", size: 23)
        
        button = CircleMenu(
            frame: CGRect.zero,
            normalIcon:"PlayNowButton_ic",
            selectedIcon:"close_ic",
            buttonsCount: 6,
            duration: 1,
            distance: 200)
        
        button.addTarget(self, action: #selector(playNowButtonTouched), for: .touchUpInside)
        button.backgroundColor = .clear
        button.delegate = self
        
        spinnerLoadingView.isHidden = true
        spinnerLoadingView.alpha = 0
        
        tapToDismissView.backgroundColor = .clear
        tapToDismissView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action:  #selector(stopSearch))
        tapToDismissView.addGestureRecognizer(tap)
        
        tapToDismisslabel.text = "Tap to cancel"
        tapToDismisslabel.textColor = .white
        tapToDismisslabel.alpha = 0
        tapToDismisslabel.textAlignment = .center
        tapToDismisslabel.font = UIFont(name: "Roboto-Medium", size: 16)
        
        view.addSubview(gameImage)
        view.addSubview(infoLabel)
        view.addSubview(buttonView)
        view.addSubview(spinnerLoadingView)
        view.addSubview(button)
        view.addSubview(tapToDismissView)
        tapToDismissView.addSubview(tapToDismisslabel)
        
        view.setNeedsUpdateConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateButton(buttonView, self.button, animate: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.buttonView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.button.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
        
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        let gameImage = UIImage(named: "\(arc4random_uniform(30))")
        
        button.setBackgroundImage(gameImage, for: .normal)
        
    }
    
    @objc func playNowButtonTouched(sender: CircleMenu) {
        
        switchButtonState()
        
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
        
        animateLoading(buttonView, button, animate: true)
    }
    
    func animateLoading(_ view: UIView, _ button: UIButton, animate: Bool) {
        if animate {
            
            tapToDismissView.isHidden = false
            
            self.infoLabel.fadeTransition(0.4)
            self.infoLabel.text = "Looking for a mate"
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState , .curveEaseInOut], animations: {() -> Void in
                
                view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                
                self.infoLabel.frame.origin.y += self.view.frame.height * 0.12
                self.infoLabel.snp.updateConstraints {(make) -> Void in
                    make.centerY.equalTo(self.view.snp.centerY).offset(-150 + self.view.frame.height * 0.12)
                }
                
                self.tapToDismisslabel.alpha = 0.5
                self.gameImage.isHidden = false
                self.gameImage.alpha = 0.05
                
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {() -> Void in
                    self.spinnerLoadingView.isHidden = false
                    self.spinnerLoadingView.alpha = 1
                })
            })
        }
    }
    
    func switchButtonState() {
        if !animatingButton { // start animating
            if buttonView.transform.a == 0.7 {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
                    self.buttonView.transform = CGAffineTransform.identity
                    self.button.transform = CGAffineTransform.identity
                    self.infoLabel.fadeTransition(0.2)
                    self.infoLabel.text = "Touch to find a mate"
                    self.infoLabel.frame.origin.y += self.view.frame.height * 0.12
                    self.infoLabel.snp.updateConstraints {(make) -> Void in
                        make.centerY.equalTo(self.view.snp.centerY).offset(-150 + self.view.frame.height * 0.12)
                    }
                }, completion: {(_ finished: Bool) -> Void in
                    self.animateButton(self.buttonView, self.button, animate: true)
                })
            } else {
                self.animateButton(self.buttonView, self.button, animate: true) // First animation start
            }
        } else { // stop animating : game selection
            UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
                self.infoLabel.frame.origin.y -= self.view.frame.height * 0.12
                self.infoLabel.snp.updateConstraints {(make) -> Void in
                    make.centerY.equalTo(self.view.snp.centerY).offset(-150 - self.view.frame.height * 0.12)
                }
            })
            self.infoLabel.fadeTransition(0.2)
            self.infoLabel.text = "Select a game"
            self.animateButton(self.buttonView, self.button, animate: false)
        }
    }
    
    func animateButton(_ view: UIView, _ button: UIButton, animate: Bool) {
        if animate {
            animatingButton = true
            UIView.animate(withDuration: 3.0, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction, .beginFromCurrentState], animations: {
                view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
        } else {
            animatingButton = false
            self.buttonView.layer.removeAllAnimations()
            self.button.layer.removeAllAnimations()
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
        }
    }
    
    @objc func stopSearch() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {() -> Void in
            self.spinnerLoadingView.alpha = 0
            self.gameImage.alpha = 0
            self.tapToDismisslabel.alpha = 0
            self.buttonView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.button.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: {(_ finished: Bool) -> Void in
            self.spinnerLoadingView.isHidden = true
            self.gameImage.isHidden = true
            self.tapToDismissView.isHidden = true
            self.animateButton(self.buttonView, self.button, animate: true)
        })
    }
    
}

// MARK: Constraints
extension PlayNowViewController {
    
    override func updateViewConstraints() {
        
        gameImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.center.equalTo(view.snp.center)
        }
        infoLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(30)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(-150)
        }
        buttonView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(buttonView.snp.width)
            make.center.equalTo(view.snp.center)
        }
        button.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(button.snp.width)
            make.center.equalTo(view.snp.center)
        }
        spinnerLoadingView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(buttonView.snp.width).multipliedBy(1.35).offset(-spinnerLoadingView.layer.lineWidth)
            make.height.equalTo(spinnerLoadingView.snp.width)
            make.center.equalTo(buttonView.snp.center)
        }
        tapToDismissView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.center.equalTo(view.snp.center)
        }
        tapToDismisslabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(tapToDismissView.snp.width).multipliedBy(0.8)
            make.height.equalTo(20)
            make.centerX.equalTo(tapToDismissView.snp.centerX)
            make.bottom.equalTo(tapToDismissView.snp.bottom).offset(-120)
        }
        
        super.updateViewConstraints()
    }
}
