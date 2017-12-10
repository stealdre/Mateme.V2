//
//  UserReviewViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 29/10/2017.
//  Copyright © 2017 Hemispher. All rights reserved.
//

import UIKit
import TTGEmojiRate
import FirebaseDatabase
import FirebaseAuth

class UserReviewViewController: UIViewController {
    
    let gradientBG = UIView()
    
    var gradientColors = [Int : [UIColor]]()
    
    let rateView = EmojiRateView()
    
    let titleLabel = UILabel()
    let label = UILabel()
    let helpLabel = UILabel()
    
    var mateID: String = ""
    var gameID: String = ""
    var date: Date!
    
    let saveButton = UIButton()
    
    var user: User!
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         user = Auth.auth().currentUser
        
        gradientColors = [0 : [UIColor(red:0.26, green:0.91, blue:0.75, alpha:1.0), UIColor(red:0.15, green:0.80, blue:                     0.24, alpha:1.0)],
                          1 : [UIColor(red:0.98, green:0.85, blue:0.38, alpha:1.0), UIColor(red:0.97, green:0.42, blue:0.11, alpha:1.0)],
                          2 : [UIColor(red:0.96, green:0.32, blue:0.37, alpha:1.0), UIColor(red:0.71, green:0.19, blue:0.27, alpha:1.0)]]
        
        rateView.backgroundColor = .clear
        rateView.rateColorRange = (.white, .white)
        rateView.rateValue = 2.5
        
        titleLabel.text = "Rate your session"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Roboto-Black", size: 28)
        
        label.text = "A bit annoying ..."
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto-Bold", size: 25)
        
        helpLabel.text = "Swipe up or down the head to rate your session"
        helpLabel.textColor = .white
        helpLabel.alpha = 0.5
        helpLabel.textAlignment = .center
        helpLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        helpLabel.lineBreakMode = .byWordWrapping
        helpLabel.numberOfLines = 2
        
        let saveButtonImage = UIImage(named: "gameSaveButton_ic")?.withRenderingMode(.alwaysTemplate)
        saveButton.setImage(saveButtonImage, for: .normal)
        saveButton.tintColor = .white
        saveButton.alpha = 1
        saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        view.addSubview(gradientBG)
        view.addSubview(titleLabel)
        view.addSubview(rateView)
        view.addSubview(label)
        view.addSubview(helpLabel)
        view.addSubview(saveButton)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let colors = gradientColors[1]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colors![0].cgColor, colors![1].cgColor]
        gradientLayer.frame = gradientBG.frame
        
        gradientBG.layer.addSublayer(gradientLayer)
        
        gradientColorsManager(gradientLayer: gradientLayer)
    }
    
    @objc func saveAction() {
        
        ref.child("users").child(user.uid).child("history").child(String(describing: date)).child("rate").setValue(Int(rateView.rateValue))
        
        dismiss(animated: true, completion: nil)
    }
    
    func gradientColorsManager(gradientLayer: CAGradientLayer) {
        
        rateView.rateValueChangeCallback = {(rateValue: Float) -> Void in
            if rateValue <= 5/3 {
                if self.label.text != "A disaster !" {
                    self.label.fadeTransition(0.4)
                    self.label.text = "A disaster !"
                }
                let colors = self.gradientColors[2] // red
                gradientLayer.colors = [colors![0].cgColor, colors![1].cgColor]
            } else if rateValue > 5/3 && rateValue < 3*5/4 {
                if self.label.text != "A bit annoying ..."{
                    self.label.fadeTransition(0.4)
                    self.label.text = "A bit annoying ..."
                }
                let colors = self.gradientColors[1] // orange
                gradientLayer.colors = [colors![0].cgColor, colors![1].cgColor]
            } else if rateValue > 3*5/4 {
                if self.label.text != "Great session !" {
                    self.label.fadeTransition(0.4)
                    self.label.text = "Great !"
                }
                let colors = self.gradientColors[0] // green
                gradientLayer.colors = [colors![0].cgColor, colors![1].cgColor]
            }
        }
    }
    
}

extension UserReviewViewController {
    
    override func updateViewConstraints() {
        
        gradientBG.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.center.equalTo(view.snp.center)
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
            make.height.equalTo(30)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(100)
        }
        rateView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(200)
            make.height.equalTo(rateView.snp.width)
            make.center.equalTo(view.snp.center)
        }
        label.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
            make.height.equalTo(28)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(rateView.snp.bottom).offset(40)
        }
        helpLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
            make.height.equalTo(40)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(label.snp.bottom).offset(20)
        }
        saveButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(174)
            make.height.equalTo(43)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
        
        super.updateViewConstraints()
    }
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}
