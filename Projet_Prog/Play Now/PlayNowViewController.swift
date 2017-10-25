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
    
    let background = UIImageView()
    
    let buttonView = PlayNowButtonView()
    
    let buttonViewIcon = UIImageView()
    
    var button: CircleMenu! = nil
    
    let infoLabel = UILabel()
    
    let spinnerLoadingView = SpinnerView()
    
    var canAnimateButton = true
    var animatingButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        background.image = UIImage(named: "Background")
        
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
        
        self.buttonView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        self.button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        spinnerLoadingView.alpha = 0
        
        self.view.addSubview(background)
        self.view.addSubview(infoLabel)
        self.view.addSubview(buttonView)
        self.view.addSubview(button)
        self.view.addSubview(spinnerLoadingView)
        
        animateButton()
        
        self.view.setNeedsUpdateConstraints()
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = UIColor(red:0.44, green:0.32, blue:0.66, alpha:1.0)
        if atIndex != 6 - 1 {
            button.contentMode = .scaleAspectFill
            button.clipsToBounds = true
            let gameImage = UIImage(named: "\(arc4random_uniform(30))")
            button.setBackgroundImage(gameImage, for: .normal)
        } else {
            let morePic = UIImage(named: "more_ic")
            button.setBackgroundImage(morePic, for: .normal)
        }
    }
    
    func menuCollapsed(_ circleMenu: CircleMenu) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {() -> Void in
            self.buttonView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.button.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: {(_ finished: Bool) -> Void in
            self.spinnerLoadingView.snp.makeConstraints {(make) -> Void in
                make.width.equalTo(self.buttonView.snp.width).multipliedBy(1.55)
                make.height.equalTo(self.spinnerLoadingView.snp.width)
                make.center.equalTo(self.buttonView.snp.center)
            }
            SwiftSpinner.show("")
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [.curveEaseInOut, .allowUserInteraction], animations: {() -> Void in
                self.spinnerLoadingView.alpha = 1
            })
        })
    }
    
    @objc func playNowButtonTouched(sender: CircleMenu) {
        if animatingButton {
            
            canAnimateButton = false
            animatingButton = false
            
            buttonView.layer.removeAllAnimations()
            button.layer.removeAllAnimations()
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {() -> Void in
                self.infoLabel.alpha = 0
                self.buttonView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }, completion: {(_ finished: Bool) -> Void in
                self.buttonView.layer.removeAllAnimations()
                self.button.layer.removeAllAnimations()
            })
        }
    }
    
    func animateButton() {
        animatingButton = true
        
        UIView.animate(withDuration: 3, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {() -> Void in
            if self.canAnimateButton {
                print("animating")
                self.buttonView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.button.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 3, delay: 1.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {() -> Void in
                if self.canAnimateButton {
                    self.buttonView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }
            }, completion: {(_ finished: Bool) -> Void in
                if self.canAnimateButton {
                    self.animateButton()
                }
            })
        })
        
    }
    
    override func updateViewConstraints() {
        
        background.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height)
            make.center.equalTo(self.view.snp.center)
        }
        infoLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.view.snp.width).multipliedBy(0.9)
            make.height.equalTo(30)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.snp.top).offset(170)
        }
        buttonView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(self.buttonView.snp.width)
            make.center.equalTo(self.view.snp.center)
        }
        button.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(self.button.snp.width)
            make.center.equalTo(self.view.snp.center)
        }
        
        super.updateViewConstraints()
    }
}
