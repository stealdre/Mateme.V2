//
//  ProfilViewController.swift
//  Projet_Prog
//
//  Created by Maxence on 13/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

	var didSetupConstraints = false
	
	var imageViewBackground = UIImageView()
	
	var profilPicView = UIImageView()
	
	var profilName = ProfilNameClass()
	
	var historyTitle = TitleClass()
	
	var historyTableView = UITableView()
	var historyTable = HistoryTableViewController()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		imageViewBackground.image = UIImage(named: "Profile_bg")
		imageViewBackground.contentMode = .scaleAspectFill

		profilPicView.image = UIImage(named: "profilPic")
		profilPicView.contentMode = .scaleAspectFill
		
		view.addSubview(imageViewBackground)
		view.sendSubview(toBack: imageViewBackground)
		
		view.addSubview(profilPicView)
		
		view.addSubview(profilName)
		view.addSubview(historyTitle)
		
		view.addSubview(historyTableView)
		historyTableView.delegate = historyTable
		historyTableView.dataSource = historyTable
		historyTableView.reloadData()
		
		view.setNeedsUpdateConstraints()
	}
	
	override func updateViewConstraints() {
		
		if !didSetupConstraints {
			
			imageViewBackground.snp.makeConstraints { (make) -> Void in
				make.width.equalTo(view.snp.width)
				make.height.equalTo(view.snp.height)
				make.centerX.equalTo(view.snp.centerX)
				make.centerY.equalTo(view.snp.centerY)
				}
			profilPicView.snp.makeConstraints { (make) -> Void in
				make.width.equalTo(view.snp.width).multipliedBy(0.4)
				make.height.equalTo(profilPicView.snp.width)
				make.centerX.equalTo(view.snp.centerX)
				make.centerY.equalTo(view.snp.centerY).multipliedBy(0.5)
			}
			profilName.snp.makeConstraints { (make) -> Void in
				make.width.equalTo(view.snp.width).multipliedBy(0.9)
				make.height.equalTo(view.snp.height).multipliedBy(0.05)
				make.centerX.equalTo(view.snp.centerX)
				make.centerY.equalTo(view.snp.centerY).multipliedBy(0.8)
			}
			historyTitle.snp.makeConstraints { (make) -> Void in
				make.width.equalTo(view.snp.width).multipliedBy(0.9)
				make.height.equalTo(view.snp.height).multipliedBy(0.05)
				make.left.equalTo(view.snp.left).offset(5)
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
	
	override func viewDidLayoutSubviews() {
		
		profilPicView.layer.borderWidth = 1
		profilPicView.layer.masksToBounds = false
		profilPicView.layer.borderColor = UIColor.black.cgColor
		profilPicView.layer.cornerRadius = profilPicView.frame.height/2
		profilPicView.clipsToBounds = true
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class HistoryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	
	var historyList = ["Fifa 18", "League of Legends", "Tera", "Overwatch", "Minecraft"]
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return historyList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		cell?.textLabel?.text = historyList[indexPath.row]
		cell?.detailTextLabel?.text = "Today"
		cell?.imageView?.image = UIImage(named: "profilPic")
		
		return cell!
	}
	
	/*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		if indexPath.row == 0 {
			return 90
		}
		return 40
	}*/
}

class ProfilNameClass: UILabel {
	
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

class TitleClass: UILabel {
	
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

/*class ProfilUITableView: UITableView {
	
	/*
	// Only override draw() if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func draw(_ rect: CGRect) {
	// Drawing code
	}
	*/
	
	override init(frame: CGRect, style: UITableViewStyle) {
		super.init(frame: frame, style: style)
		commonInt()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func commonInt() {
		
		self.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		
	}
	
}*/


class ProfilTableViewCell: UITableViewCell {
	
	//var mateName = UILabel()
	var gameDate = UILabel()
	
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
	}
}
