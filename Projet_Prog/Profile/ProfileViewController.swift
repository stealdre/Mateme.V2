//
//  ProfilViewController.swift
//  Projet_Prog
//
//  Created by Maxence on 13/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource {
    
    var didSetupConstraints = false
	
    var imageViewBackground = UIImageView()
    
    var profileName = ProfileName()
    var historyTitle = HistoryCellTitle()
    
    var profilePic = RoundImageView()
    let ProfilePicWhiteBorder = UIView()
    let ProfilePicAlphaBorder = UIView()
    
    var historyList = ["Fifa 18", "League of Legends", "Tera", "Overwatch", "Minecraft"]
    
    var historyTableView = ProfileTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewBackground.image = UIImage(named: "Background")
        imageViewBackground.contentMode = .scaleAspectFill
        
        view.addSubview(historyTitle)
        
        view.addSubview(profilePic)
        
        view.addSubview(imageViewBackground)
        view.sendSubview(toBack: imageViewBackground)
        
        view.addSubview(profileName)
        
        view.addSubview(historyTableView)
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        historyTableView.reloadData()
        
        profilePic.image = UIImage(named: "profilPic")
		
		historyTableView.backgroundColor = .clear
        
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            imageViewBackground.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height)
                make.center.equalTo(view.snp.center)
            }
            
            profilePic.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width).multipliedBy(0.4)
                make.height.equalTo(profilePic.snp.width)
                make.centerX.equalTo(view.snp.centerX)
                make.centerY.equalTo(view.snp.centerY).multipliedBy(0.5)
            }
            
            profileName.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width).multipliedBy(0.9)
                make.height.equalTo(view.snp.height).multipliedBy(0.05)
                make.centerX.equalTo(view.snp.centerX)
                make.centerY.equalTo(view.snp.centerY).multipliedBy(0.8)
            }
            
            historyTitle.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width).multipliedBy(0.9)
                make.height.equalTo(view.snp.height).multipliedBy(0.05)
                make.leftMargin.equalTo(15)
                make.centerY.equalTo(view.snp.centerY)
            }
            historyTableView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width)
                make.top.equalTo(historyTitle.snp.bottom).offset(10)
                make.centerX.equalTo(view.snp.centerX)
                make.bottom.equalTo(view.snp.bottom).inset(10)
                
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ProfileTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? ProfileTableViewCell
        
		
        cell?.gamePic.image = UIImage(named: "\(indexPath.row)")
		cell?.mateName.text = "Player \(indexPath.row)"
		cell?.gameName.text = historyList[indexPath.row]
		
		cell?.backgroundColor = .clear

		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "dd-MM-yyyy"
		cell?.sessionDate.text = formatter.string(from: date)
		
        cell?.selectionStyle = .none
        
        return cell!
    }
}

class ProfileName: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addProprieties()
    }
    
    func addProprieties() {
        self.textAlignment = .center
        self.font = UIFont(name: self.font.fontName, size: 25)
        self.text = "Boby"
    }
}

class HistoryCellTitle: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addProprieties()
    }
    
    func addProprieties() {
        self.textAlignment = .left
        self.font = UIFont(name: self.font.fontName, size: 30)
        self.text = "HISTORY"
    }
}

class ProfileTableView: UITableView {
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInt()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInt() {
        
        self.register(ProfileTableViewCell.self, forCellReuseIdentifier: "historyCell")
        
    }
    
}

class RoundImageView: UIImageView {
    
    override func layoutSubviews() {
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
        
    }
    
}

