//
//  MenuViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 12/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UIScrollViewDelegate {
    
    var didSetupConstraints = false

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
    
    let playNowVC = PlayNowViewController()
    let profileVC = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(horizontalScrollView)
        
        addChildViewController(profileVC)
        horizontalScrollView.addSubview(profileVC.view)
        profileVC.didMove(toParentViewController: self)
        
        addChildViewController(playNowVC)
        horizontalScrollView.addSubview(playNowVC.view)
        playNowVC.didMove(toParentViewController: self)

        horizontalScrollView.contentOffset = CGPoint(x: 0, y: 0)
        horizontalScrollView.contentSize = CGSize(width: view.frame.size.width * 2, height: view.frame.size.height)

        view.setNeedsUpdateConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //view.layer.layoutIfNeeded()
    }
    

    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            horizontalScrollView.snp.makeConstraints { (make) -> Void in
                make.center.equalTo(view.snp.center)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height)
            }
            
            playNowVC.view.snp.makeConstraints { (make) -> Void in
                make.left.equalTo(horizontalScrollView.snp.left)
                make.bottom.equalTo(view.snp.bottom)
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height)
            }
            
            profileVC.view.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height)
                make.left.equalTo(playNowVC.view.snp.left).offset(view.frame.size.width)
                make.bottom.equalTo(view.snp.bottom)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }

}
