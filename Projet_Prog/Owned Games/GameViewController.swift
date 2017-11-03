//
//  GameViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 29/10/2017.
//  Copyright © 2017 Hemispher. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    lazy var VerticalScrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.tag = 10
        view.backgroundColor = .clear
        view.bounces = false
        view.contentSize = CGSize(width: 1, height: 1)
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    let topContainerView = UIView()
    let botContainerView = UIView()
    
    let gameImage = UIImageView()
    let gameIcon = UIImageView()
    
    let gameTypeLabel = UILabel()
    let gameNameLabel = UILabel()
    
    let sessionNumberIcon = UIImageView()
    let sessionNumberLabel = UILabel()
    let lastSessionIcon = UIImageView()
    let lastSessionLabel = UILabel()
    
    let moreButton = UIButton()
    
    let playButton = UIButton()
    let saveButton = UIButton()
    
    let closeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)

        VerticalScrollView.contentOffset = CGPoint(x: 0, y: 0)
        VerticalScrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height * 2)
        
        topContainerView.backgroundColor = .clear
        botContainerView.backgroundColor = .clear
        
        gameImage.image = UIImage(named: "35")
        gameImage.contentMode = .scaleAspectFill
        gameImage.alpha = 0.1
        
        gameIcon.image = UIImage(named: "League_of_Legends_Icon")
        
        gameTypeLabel.text = "MOBA"
        gameTypeLabel.textColor = .black
        gameTypeLabel.alpha = 0.4
        gameTypeLabel.font = UIFont(name: "Roboto-Medium", size: 30)
        gameTypeLabel.textAlignment = .left
        
        gameNameLabel.text = "LEAGUE OF LEGENDS OF LEGENDS"
        gameNameLabel.lineBreakMode = .byWordWrapping
        gameNameLabel.numberOfLines = 3
        gameNameLabel.minimumScaleFactor = 0.2
        gameNameLabel.adjustsFontSizeToFitWidth = true
        gameNameLabel.textColor = .black
        gameNameLabel.font = UIFont(name: "Roboto-Black", size: 49)
        gameNameLabel.textAlignment = .left
        
        sessionNumberIcon.image = UIImage(named: "gamepad_ic")
        sessionNumberIcon.image = sessionNumberIcon.image!.withRenderingMode(.alwaysTemplate)
        sessionNumberIcon.tintColor = .black
        sessionNumberIcon.alpha = 0.6
        
        sessionNumberLabel.text = "3"
        sessionNumberLabel.textColor = .black
        sessionNumberLabel.alpha = 0.6
        sessionNumberLabel.font = UIFont(name: "Roboto-Regular", size: 30)
        sessionNumberLabel.textAlignment = .left
        
        lastSessionIcon.image = UIImage(named: "clock_ic")
        lastSessionIcon.image = lastSessionIcon.image!.withRenderingMode(.alwaysTemplate)
        lastSessionIcon.tintColor = .black
        lastSessionIcon.alpha = 0.6
        
        lastSessionLabel.text = "Last: 07/11/2017"
        lastSessionLabel.textColor = .black
        lastSessionLabel.alpha = 0.6
        lastSessionLabel.font = UIFont(name: "Roboto-Regular", size: 30)
        lastSessionLabel.textAlignment = .left
        
        let moreButtonImage = UIImage(named: "downArrow_ic")?.withRenderingMode(.alwaysTemplate)
        moreButton.setImage(moreButtonImage, for: .normal)
        moreButton.tintColor = .gray
        moreButton.addTarget(self, action: #selector(moreButtonAction(sender:)), for: .touchUpInside)
        
        let playButtonImage = UIImage(named: "gamePlayButton_ic")?.withRenderingMode(.alwaysTemplate)
        playButton.setImage(playButtonImage, for: .normal)
        playButton.tintColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:1.0)
        
        let saveButtonImage = UIImage(named: "gameSaveButton_ic")?.withRenderingMode(.alwaysTemplate)
        saveButton.setImage(saveButtonImage, for: .normal)
        saveButton.tintColor = UIColor(red:0.29, green:0.56, blue:0.89, alpha:1.0)
        saveButton.alpha = 0
        
        closeButton.setImage(UIImage(named: "close_ic"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        
        view.addSubview(gameImage)
        view.addSubview(gameIcon)
        
        view.addSubview(VerticalScrollView)
        VerticalScrollView.addSubview(topContainerView)
        VerticalScrollView.addSubview(botContainerView)
        
        topContainerView.addSubview(gameTypeLabel)
        topContainerView.addSubview(gameNameLabel)
        
        topContainerView.addSubview(sessionNumberIcon)
        topContainerView.addSubview(sessionNumberLabel)
        topContainerView.addSubview(lastSessionIcon)
        topContainerView.addSubview(lastSessionLabel)
        
        topContainerView.addSubview(moreButton)
        
        view.addSubview(playButton)
        view.addSubview(saveButton)
        view.addSubview(closeButton)
        
        view.setNeedsUpdateConstraints()
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }

    
    @objc func moreButtonAction(sender: UIButton!) {
        VerticalScrollView.setContentOffset(CGPoint(x: 0, y: view.frame.height), animated: true)
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Scroll view Delegate
extension GameViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollY = scrollView.contentOffset.y
        if scrollY < view.frame.height * 0.5 { // addressBook
            let alpha = (1  - (scrollY / (self.view.frame.height * 0.5)))
            self.playButton.alpha = alpha
        } else {
            let alpha =  (scrollY / (self.view.frame.height * 0.5)) - 1
            self.saveButton.alpha = alpha
        }
    }
}

// MARK: Constraints
extension GameViewController {
    
    override func updateViewConstraints() {
        
        gameImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.center.equalTo(view.snp.center)
        }
        VerticalScrollView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.center.equalTo(view.snp.center)
        }
        topContainerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.centerX.equalTo(VerticalScrollView.snp.centerX)
            make.top.equalTo(VerticalScrollView.snp.top)
        }
        botContainerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(topContainerView.snp.width)
            make.height.equalTo(topContainerView.snp.height)
            make.centerX.equalTo(VerticalScrollView.snp.centerX)
            make.top.equalTo(VerticalScrollView.snp.top).offset(view.frame.height)
        }
        gameTypeLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(topContainerView.snp.width).multipliedBy(0.8)
            make.height.equalTo(32)
            make.left.equalTo(topContainerView.snp.left).offset(20)
            make.bottom.equalTo(gameNameLabel.snp.top)
        }
        gameNameLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(topContainerView.snp.width).multipliedBy(0.8)
            make.height.equalTo(heightForView(text: "LEAGUE OF LEGENDS", font: UIFont(name: "Roboto-Black", size: 49)!, width: view.frame.width * 0.8))
            make.left.equalTo(topContainerView.snp.left).offset(20)
            make.bottom.equalTo(sessionNumberIcon.snp.top).offset(-20)
        }
        gameIcon.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(topContainerView.snp.width).multipliedBy(0.7)
            make.height.equalTo(gameIcon.snp.height)
            make.centerX.equalTo(topContainerView.snp.centerX)
            make.bottom.equalTo(gameTypeLabel.snp.top).offset(-20)
        }
        sessionNumberIcon.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(25)
            make.height.equalTo(18.75)
            make.left.equalTo(topContainerView.snp.left).offset(20)
            make.bottom.equalTo(lastSessionIcon.snp.top).offset(-15)
        }
        sessionNumberLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(topContainerView.snp.width).multipliedBy(0.5)
            make.height.equalTo(22)
            make.left.equalTo(sessionNumberIcon.snp.right).offset(10)
            make.centerY.equalTo(sessionNumberIcon.snp.centerY)
        }
        lastSessionIcon.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.left.equalTo(topContainerView.snp.left).offset(20)
            make.bottom.equalTo(topContainerView.snp.bottom).inset(130) // Bottom reference
        }
        lastSessionLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(topContainerView.snp.width).multipliedBy(0.8)
            make.height.equalTo(22)
            make.left.equalTo(lastSessionIcon.snp.right).offset(10)
            make.centerY.equalTo(lastSessionIcon.snp.centerY)
        }
        moreButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerX.equalTo(topContainerView.snp.centerX)
            make.top.equalTo(lastSessionIcon.snp.bottom).offset(20)
        }
        playButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(174)
            make.height.equalTo(43)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
        saveButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(174)
            make.height.equalTo(43)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
        closeButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.right.equalTo(view.snp.right).offset(-20)
            make.top.equalTo(view.snp.top).offset(30)
        }
        
        super.updateViewConstraints()
    }
    
}
