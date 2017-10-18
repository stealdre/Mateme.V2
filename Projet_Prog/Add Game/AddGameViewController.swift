//
//  ViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 11/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class AddGameViewController: UIViewController, UITableViewDelegate {
    
    var didSetupConstraints = false
    
    var containerView = ShadowNCornerRadiusView()
    
    var imageView = RoundedCornerNgradientImageView()
    
    let tableView = AddGameUITableView()
    
    let VCtitleLabel = UILabel()
    
    let gameNameLabel = UILabel()
    let gameTypeLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.backgroundColor = .white
  
        VCtitleLabel.text = "Call of Duty WW1"
        VCtitleLabel.font = UIFont(name: "Roboto-Black", size: 30)
        
        self.view.addSubview(VCtitleLabel)
        self.view.addSubview(containerView)
        
        imageView.image = UIImage(named: "profilePicture")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        gameNameLabel.text = "Call of Duty WWI"
        gameNameLabel.font = UIFont(name: "Roboto-Black", size: 25)
        gameNameLabel.textColor = .white

        
        gameTypeLabel.text = "FPS"
        gameTypeLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        gameTypeLabel.alpha = 0.8
        gameTypeLabel.textColor = .white
        
        containerView.addSubview(imageView)
        containerView.addSubview(gameNameLabel)
        containerView.addSubview(gameTypeLabel)
        containerView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()

        view.setNeedsUpdateConstraints()
        
    }
    
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            addConstraints()
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension AddGameViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell?.textLabel?.text = "Cell \(indexPath.row)"
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 90
        }
        
        return 40
    }
    
}

extension AddGameViewController {
    
    func addConstraints() {
        
        VCtitleLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(35)
            make.leftMargin.equalTo(containerView.snp.leftMargin)
            make.bottom.equalTo(containerView.snp.top).offset(-10)
        }
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(view.snp.height).multipliedBy(0.83)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(30)
        }
        
        gameNameLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width)
            make.height.equalTo(25)
            make.leftMargin.equalTo(containerView.snp.leftMargin).offset(10)
            make.bottom.equalTo(gameTypeLabel.snp.top)
        }
        
        gameTypeLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width)
            make.height.equalTo(25)
            make.leftMargin.equalTo(gameNameLabel.snp.leftMargin)
            make.bottom.equalTo(imageView.snp.bottom).offset(-5)
        }
        
        imageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width)
            make.height.equalTo(view.snp.height).multipliedBy(0.25)
            make.top.equalTo(containerView.snp.top)
            make.centerX.equalTo(containerView.snp.centerX)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width)
            make.top.equalTo(imageView.snp.bottom)
            make.centerX.equalTo(containerView.snp.centerX)
            make.bottom.equalTo(containerView.snp.bottom).inset(10)
        }
    }
}



