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

class PlayNowViewController: UIViewController, CircleMenuDelegate {
    
    let buttonView = PlayNowButtonView()
    
    let buttonViewIcon = UIImageView()
    
    var button: CircleMenu! = nil
    
    let infoLabel = UILabel()
    
    let spinnerLoadingView = SpinnerView()
    
    var canAnimateButton = true
    var animatingButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.view.addSubview(infoLabel)
        self.view.addSubview(buttonView)
        self.view.addSubview(spinnerLoadingView)
        self.view.addSubview(button)
        
        self.view.setNeedsUpdateConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateButton(buttonView, self.button, animate: true)
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
            UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState , .curveEaseInOut], animations: {() -> Void in
                view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {(_ finished: Bool) -> Void in

                //SwiftSpinner.show("")
                UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {() -> Void in
                    self.spinnerLoadingView.isHidden = false
                    self.spinnerLoadingView.alpha = 1
                })
            })
        } else {
            
        }
    }
    
    func switchButtonState() {
        if !animatingButton { // start animating
            if buttonView.transform.a == 0.7 {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
                    self.buttonView.transform = CGAffineTransform.identity
                    self.button.transform = CGAffineTransform.identity
                    self.infoLabel.alpha = 1
                }, completion: {(_ finished: Bool) -> Void in
                    self.animateButton(self.buttonView, self.button, animate: true)
                })
            } else {
                self.animateButton(self.buttonView, self.button, animate: true) // First animation start
            }
        } else { // stop animating
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
                self.infoLabel.alpha = 0
            })
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
    
}

// MARK: Constraints
extension PlayNowViewController {
    
    override func updateViewConstraints() {

        infoLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(30)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(170)
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
            make.width.equalTo(buttonView.snp.width).multipliedBy(1.35)
            make.height.equalTo(spinnerLoadingView.snp.width)
            make.center.equalTo(buttonView.snp.center)
        }
        
        super.updateViewConstraints()
    }
}
