//
//  MenuViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 12/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import CHIPageControl

class MenuViewController: UIViewController, UIScrollViewDelegate {
    
    let pageControl = CHIPageControlAleppo()
    
    lazy var horizontalScrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.tag = 10
        view.backgroundColor = .clear
        view.bounces = false
        view.contentSize = CGSize(width: 1, height: 1)
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    let backgroundGradient = UIImageView()
    
    let searchVC = OwnedGamesViewController() // Left
    let playNowVC = PlayNowViewController() // Middle
    let profileVC = ProfileViewController() // Right
    
    let profileButton = UIButton()
    let gamesButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundGradient.image = UIImage(named: "Background")
        
        pageControl.numberOfPages = 3
        pageControl.padding = 6
        pageControl.radius = 4
        pageControl.tintColor = .white
        pageControl.currentPageTintColor = .white
        pageControl.progress = 0.5
        
        profileButton.setImage(UIImage(named: "profile_ic"), for: .normal)
        gamesButton.setImage(UIImage(named: "games_ic"), for: .normal)
        
        view.addSubview(horizontalScrollView)
        
        view.addSubview(backgroundGradient)
        view.sendSubview(toBack: backgroundGradient)
        
        addChildViewController(searchVC)
        horizontalScrollView.addSubview(searchVC.view)
        searchVC.didMove(toParentViewController: self)
        
        addChildViewController(profileVC)
        horizontalScrollView.addSubview(profileVC.view)
        profileVC.didMove(toParentViewController: self)
        
        addChildViewController(playNowVC)
        horizontalScrollView.addSubview(playNowVC.view)
        playNowVC.didMove(toParentViewController: self)
        
        horizontalScrollView.contentOffset = CGPoint(x: view.frame.size.width, y: 0)
        horizontalScrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: view.frame.size.height)
        
        gamesButton.addTarget(self, action: #selector(gamesButtonAction), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(profileButtonAction), for: .touchUpInside)
        
        view.addSubview(pageControl)
        view.addSubview(profileButton)
        view.addSubview(gamesButton)
        
        view.setNeedsUpdateConstraints()
    }
    
    
}

// MARK: Scroll view Delegate
extension MenuViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        
        if xOffset > view.frame.size.width {
            profileButton.alpha = (1  - ((xOffset - view.frame.width) / view.frame.width) * 1.5)
            gamesButton.alpha = (1  - ((xOffset - view.frame.width) / view.frame.width) * 1.5)
        } else {
            gamesButton.alpha = xOffset / view.frame.width
            profileButton.alpha = xOffset / view.frame.width
        }
        
        pageControl.progress = Double(xOffset / scrollView.frame.width)
    }
}

// MARK: Buttons actions
extension MenuViewController {
    
    @objc func gamesButtonAction() {
        horizontalScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @objc func profileButtonAction() {
        horizontalScrollView.setContentOffset(CGPoint(x: view.frame.width * 2, y: 0), animated: true)
    }
}


// MARK: Constraints
extension MenuViewController {
    
    override func updateViewConstraints() {
        
        horizontalScrollView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(view.snp.center)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
        }
        backgroundGradient.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(view.snp.center)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
        }
        searchVC.view.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(horizontalScrollView.snp.left)
            make.bottom.equalTo(view.snp.bottom)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
        }
        playNowVC.view.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(horizontalScrollView.snp.left).offset(view.frame.size.width)
            make.bottom.equalTo(view.snp.bottom)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
        }
        profileVC.view.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.left.equalTo(horizontalScrollView.snp.left).offset(view.frame.size.width * 2)
            make.bottom.equalTo(view.snp.bottom)
        }
        pageControl.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(25)
            make.height.equalTo(5)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(60)
        }
        gamesButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(43)
            make.height.equalTo(32)
            make.left.equalTo(view.snp.left).offset(20)
            make.top.equalTo(view.snp.top).offset(35)
        }
        profileButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(24)
            make.height.equalTo(32)
            make.right.equalTo(view.snp.right).inset(20)
            make.top.equalTo(view.snp.top).offset(35)
        }
        
        super.updateViewConstraints()
    }
    
}
