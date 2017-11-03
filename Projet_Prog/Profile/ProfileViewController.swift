//
//  ProfilViewController.swift
//  Projet_Prog
//
//  Created by Maxence on 13/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource {
    
    var VCtitleLabel = UILabel()
    
    var profileName = ProfileName()
    var historyTitle = HistoryCellTitle()
    
    let profilePic = RoundImageView()
    let ProfilePicWhiteBorder = UIView()
    let ProfilePicAlphaBorder = UIView()
    let profilePicOrnament = UIImageView()
    let lineView = UIView()
    
    var historyList = ["Fifa 18", "League of Legends", "Tera", "Overwatch", "Minecraft"]
    
    var historyTableView = ProfileTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        VCtitleLabel.text = "Profile"
        VCtitleLabel.textColor = .white
        VCtitleLabel.font = UIFont(name: "Roboto-Bold", size: 19)
        VCtitleLabel.textAlignment = .center
        
        profileName.text = "UserName"
        profileName.textColor = .white
        profileName.font = UIFont(name: "Roboto-Medium", size: 20)
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        profilePicOrnament.image = UIImage(named: "profilePicOrnament")
        
        profilePic.image = UIImage(named: "profilPic")
        
        lineView.backgroundColor = .white
        lineView.alpha = 0.1
        
        historyTitle.textColor = .white
        
        historyTableView.backgroundColor = .clear
        historyTableView.separatorStyle = .none
        historyTableView.rowHeight = 90
        
        view.addSubview(VCtitleLabel)
        view.addSubview(historyTitle)
        view.addSubview(profilePicOrnament)
        view.addSubview(profilePic)
        view.addSubview(profileName)
        view.addSubview(lineView)
        view.addSubview(historyTableView)
        
        historyTableView.reloadData()
        
        view.setNeedsUpdateConstraints()
    }
    
}

// MARK: Table view delegate
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ProfileTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? ProfileTableViewCell
        
        if cell != nil {
            
            cell?.backgroundColor = .clear
            cell?.contentView.backgroundColor = .clear
            
            cell?.containerView.layer.cornerRadius = 10
            cell?.containerView.clipsToBounds = true
            
            cell?.gamePic.image = UIImage(named: "\(indexPath.row)")
            cell?.mateName.text = "Player \(indexPath.row)"
            cell?.gameName.text = historyList[indexPath.row]
            
            
            let date = Date()
            var dateString = ""
            switch dayDifference(date: date) {
            case 0:
                dateString = "Today"
                cell?.sessionDate.text = dateString
                break
            case -1:
                dateString = "Yesterday"
                cell?.sessionDate.text = dateString
                break
            default:
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                cell?.sessionDate.text = formatter.string(from: date)
            }
            
            cell?.selectionStyle = .none
        }
        return cell!
    }
}

// MARK: Data
extension ProfileViewController {
    
    func dayDifference(date : Date) -> Int {
        let calendar = Calendar.current
        if calendar.isDateInYesterday(date) { return -1 }
        else if calendar.isDateInToday(date) { return 0 }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            return day
        }
    }
}

// MARK: Constraints
extension ProfileViewController {
    
    override func updateViewConstraints() {
        VCtitleLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.6)
            make.height.equalTo(20)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(30)
        }
        profilePic.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.4)
            make.height.equalTo(profilePic.snp.width)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.5)
        }
        profilePicOrnament.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(340)
            make.height.equalTo(176)
            make.center.equalTo(profilePic.snp.center)
        }
        profileName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(view.snp.height).multipliedBy(0.05)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(profilePicOrnament.snp.bottom).offset(10)
        }
        lineView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(70)
            make.height.equalTo(1)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(profileName.snp.bottom).offset(10)
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
        
        super.updateViewConstraints()
    }
}

class ProfileName: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addProperties()
    }
    
    func addProperties() {
        self.textAlignment = .center
        self.font = UIFont(name: self.font.fontName, size: 25)
    }
}

class HistoryCellTitle: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addProprieties()
    }
    
    func addProprieties() {
        self.textAlignment = .left
        self.font = UIFont(name: self.font.fontName, size: 20)
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
