//
//  ProfileViewController.swift
//  Projet_Prog
//
//  Created by Maxence on 13/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController, UITableViewDataSource, UIImagePickerControllerDelegate,UIPopoverControllerDelegate, UINavigationControllerDelegate {
	
	var VCtitleLabel = UILabel()
	
	var profileName = ProfileName()
	var historyTitle = HistoryCellTitle()
	
	var picker:UIImagePickerController?=UIImagePickerController()
	
	let profilePic = UIButton()
	let ProfilePicWhiteBorder = UIView()
	let ProfilePicAlphaBorder = UIView()
	let profilePicOrnament = UIImageView()
	let lineView = UIView()
    let logoutButton = UIButton()
	
	var historyTableView = ProfileTableView()
	
	var user: User!
	var ref: DatabaseReference!
	private var databaseHandle: DatabaseHandle!
	var storage: Storage!
	var storageRef: StorageReference!
	
	var profileDB: Profile!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		user = Auth.auth().currentUser
		ref = Database.database().reference()
		storage = Storage.storage()
		storageRef = storage.reference()
		
		picker?.delegate = self
		
		view.backgroundColor = .clear
		profilePic.backgroundColor = .clear
		
		VCtitleLabel.text = "Profile"
		VCtitleLabel.textColor = .white
		VCtitleLabel.font = UIFont(name: "Roboto-Bold", size: 19)
		VCtitleLabel.textAlignment = .center
        
        logoutButton.setImage(UIImage(named: "logout_ic"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
		
		profileName.textColor = .white
		profileName.font = UIFont(name: "Roboto-Medium", size: 20)
		
		historyTableView.delegate = self
		historyTableView.dataSource = self
		
		profilePicOrnament.image = UIImage(named: "profilePicOrnament")
		
		lineView.backgroundColor = .white
		lineView.alpha = 0.1
		
		historyTitle.textColor = .white
		
		historyTableView.backgroundColor = .clear
		historyTableView.separatorStyle = .none
		historyTableView.rowHeight = 90
		
		view.addSubview(VCtitleLabel)
        view.addSubview(logoutButton)
		view.addSubview(historyTitle)
		view.addSubview(profilePicOrnament)
		view.addSubview(profilePic)
		view.addSubview(profileName)
		view.addSubview(lineView)
		view.addSubview(historyTableView)
		
		view.setNeedsUpdateConstraints()
		
		profilePic.addTarget(self, action: #selector(setProfilePic), for: .touchUpInside)
		
		getProfileData() { profileInfo in
			self.profileDB = profileInfo
			let array = self.profileDB.historiesArray
			for i in 0..<array.count {
				self.getValueFromID(type: "users", id: array[i].mateID) { userName in
					self.profileDB.historiesArray[i].mateName = userName
					self.getValueFromID(type: "games", id: array[i].gameID) { gameName in
					self.profileDB.historiesArray[i].gameName = gameName
					self.historyTableView.reloadData()
					}
				}
			}
			
			self.profileName.text = self.profileDB.name //"UserName"
			self.getStorageImage(url: self.profileDB.profilPicPath) { image in
				self.profilePic.setImage(image, for: .normal)
			}
		}
	}
	override func viewDidLayoutSubviews() {
		profilePic.layer.masksToBounds = true
		profilePic.layer.cornerRadius = profilePic.frame.height/2
		profilePic.clipsToBounds = true
	}
}


extension ProfileViewController {
    
    @objc func logout() {
        print("logout")
		if Auth.auth().currentUser != nil {
			do {
				try Auth.auth().signOut()
				self.present(LoginViewController(), animated: true, completion: nil)
			} catch let error as NSError {
				print(error.localizedDescription)
			}
		}
    }
	
	func getProfileData(completion: @escaping (_ data: Profile) -> Void) {
		
        ref.child("users").child("user1").observeSingleEvent(of: .value, with: { (snapshot) in
			let data = Profile(snapshot: snapshot)
			completion(data)
		})
	}
	
	func getStorageImage(url: String, completion: @escaping (_ image: UIImage) -> Void) {
		let storage = Storage.storage()
		let pathReference = storage.reference(withPath: url)
		pathReference.getData(maxSize: 1 * 5000 * 5000) { data, error in
			if let error = error {
				print(error)
			}
			else {
				// Data for "images/island.jpg" is returned
				let image = UIImage(data: data!)
				if image != nil {
					completion(image!)
				}
			}
		}
	}
	
	func getValueFromID(type: String, id: String, completion: @escaping (_ name: String) -> Void) {
		print(type)
        print(id)
        ref.child(type).child(id).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
			let name = snapshot.value as! String
			completion(name)
		})
	}
	
	@objc func setProfilePic() {
		let alertController = UIAlertController(title: nil, message: "Take or select a picture from your gallery.", preferredStyle: .actionSheet)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
			// ...
		}
		alertController.addAction(cancelAction)
		
		let TakePicture = UIAlertAction(title: "Take picture", style: .default) { action in
			if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
				self.picker!.allowsEditing = false
				self.picker!.sourceType = UIImagePickerControllerSourceType.camera
				self.picker!.cameraCaptureMode = .photo
				self.present(self.picker!, animated: true, completion: nil)
			}else{
				let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
				let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
				alert.addAction(ok)
				self.present(alert, animated: true, completion: nil)
			}
		}
		alertController.addAction(TakePicture)
		
		let SelectGallery = UIAlertAction(title: "Select from gallery", style: .default) { action in
			self.picker!.allowsEditing = true
			self.picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
			self.present(self.picker!, animated: true, completion: nil)
		}
		alertController.addAction(SelectGallery)
		
		self.present(alertController, animated: true) {
			// ...
		}
	}
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		//print(info)
		print("ououiuou")
		let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		//imageView.contentMode = .scaleAspectFit
		self.profilePic.setImage(chosenImage, for: .normal)
		
		storeImage()//:::::::::::::::::::::::::::::::::::
		
		dismiss(animated: true, completion: nil)
	}
	
	func storeImage() {
		let imageRef = storageRef.child("usersProfilePic/\(user.uid).jpg")
		if let uploadData = UIImageJPEGRepresentation(profilePic.currentImage!, 0.3) {
			let metadata = StorageMetadata()
			metadata.contentType = "image/jpeg"
			
			let uploadTask = imageRef.putData(uploadData, metadata: metadata) { (metadata, error) in
				if let _ = metadata {
				} else {
					print("ERROr")
					print(error?.localizedDescription as Any)
					return
				}
				self.ref.child("users").child(self.user.uid).child("profilePicPath").setValue("usersProfilePic/\(self.user.uid).jpg")
			}
			uploadTask.observe(.progress, handler: { (snapshot) in
				guard let progress = snapshot.progress else {
					return
				}
				//let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
			})
		}
	}
}

// MARK: Table view delegate
extension ProfileViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if profileDB != nil {
			return profileDB.historiesArray.count
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell: ProfileTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? ProfileTableViewCell
		
		if cell != nil {
			
			cell?.backgroundColor = .clear
			cell?.contentView.backgroundColor = .clear
			
			cell?.containerView.layer.cornerRadius = 10
			cell?.containerView.clipsToBounds = true
			
			cell?.mateName.text = profileDB.historiesArray[indexPath.row].mateName
			cell?.gameName.text = profileDB.historiesArray[indexPath.row].gameName
				
			let url = "gamesImage/\(profileDB.historiesArray[indexPath.row].gameID).png"
			print(url)
			getStorageImage(url: url) { image in
				cell?.gamePic.image = image
			}

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

// MARK: Date
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
        logoutButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(31)
            make.height.equalTo(32)
            make.right.equalTo(view.snp.right).inset(20)
            make.top.equalTo(view.snp.top).offset(35)
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

