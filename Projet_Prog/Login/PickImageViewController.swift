//
//  PickImageViewController.swift
//  Projet_Prog
//
//  Created by Maxence on 21/11/2017.
//  Copyright © 2017 Hemispher. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class PickImageViewController: UIViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate, UINavigationControllerDelegate {
	
	
	var imageView = RoundImageView()
	var takePickButton = UIButton()
	var openGalleryButton = UIButton()
	
	var picker:UIImagePickerController?=UIImagePickerController()
	
	var ref: DatabaseReference!
	var user: User!
	var storage: Storage!
	var storageRef: StorageReference!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		picker?.delegate=self
		
		takePickButton.setTitle("Take picture", for: .normal)
		takePickButton.backgroundColor = .black
		takePickButton.setTitleColor(.white, for: .normal)
		
		openGalleryButton.setTitle("Select from gallery", for: .normal)
		openGalleryButton.backgroundColor = .black
		openGalleryButton.setTitleColor(.white, for: .normal)
		
		
		takePickButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
		openGalleryButton.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
		
		view.addSubview(takePickButton)
		view.addSubview(openGalleryButton)
		view.addSubview(imageView)
		
		view.setNeedsUpdateConstraints()
		
		ref = Database.database().reference()
		user = Auth.auth().currentUser
		storage = Storage.storage()
		storageRef = storage.reference()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		
	}
	
	@objc func openGallery()
	{
		picker!.allowsEditing = true
		picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
		present(picker!, animated: true, completion: nil)
	}
	
	
	@objc func openCamera()
	{
		if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
			picker!.allowsEditing = false
			picker!.sourceType = UIImagePickerControllerSourceType.camera
			picker!.cameraCaptureMode = .photo
			present(picker!, animated: true, completion: nil)
		}else{
			let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
			let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
			alert.addAction(ok)
			present(alert, animated: true, completion: nil)
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		//print(info)
		let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		//imageView.contentMode = .scaleAspectFit
		imageView.image = chosenImage
		
		storeImage()//:::::::::::::::::::::::::::::::::::
		
		//facetime(phoneNumber: "0698284498")
		
		dismiss(animated: true, completion: nil)
	}
	
	func storeImage() {
		let imageRef = storageRef.child("usersProfilePic/\(user.uid).jpg")
		if let uploadData = UIImageJPEGRepresentation(self.imageView.image!, 0.5) {
			let metadata = StorageMetadata()
			metadata.contentType = "image/jpeg"
			
			let uploadTask = imageRef.putData(uploadData, metadata: metadata) { (metadata, error) in
				if let _ = metadata {
				} else {
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
	
	private func facetime(phoneNumber:String) {
		let cleanNumber = phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
		if let facetimeURL:URL = URL(string: "facetime-audio://\(cleanNumber)") {
			let application:UIApplication = UIApplication.shared
			if (application.canOpenURL(facetimeURL)) {
				application.open(facetimeURL,options: [:], completionHandler: nil)
			}
		}
	}
}

extension PickImageViewController {
	
	override func updateViewConstraints() {
		imageView.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(imageView.snp.width)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(view.snp.centerY).multipliedBy(0.5)
		}
		takePickButton.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(view.snp.centerY)
		}
		openGalleryButton.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(view.snp.width).multipliedBy(0.6)
			make.height.equalTo(50)
			make.centerX.equalTo(view.snp.centerX)
			make.centerY.equalTo(takePickButton.snp.bottom).offset(30)
		}
		super.updateViewConstraints()
	}
}
