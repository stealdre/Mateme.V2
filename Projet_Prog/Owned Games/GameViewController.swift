//
//  GameViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 29/10/2017.
//  Copyright © 2017 Hemispher. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SkyFloatingLabelTextField

class GameViewController: UIViewController {
	
	var user: User!
	var ref: DatabaseReference!
    
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

	let sliderLevel = UISlider()
	var levelLabel = UILabel()
	let sliderFrequency = UISlider()
	var frequencyLabel = UILabel()
	var pseudoTextField = SkyFloatingLabelTextField()
	let pseudoLabel = UILabel()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black

		user = Auth.auth().currentUser
		ref = Database.database().reference()
		
        definesPresentationContext = true
        
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)

        VerticalScrollView.contentOffset = CGPoint(x: 0, y: 0)
        VerticalScrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height * 2)
        
        topContainerView.backgroundColor = .clear
        botContainerView.backgroundColor = .clear
        
        //gameImage.image = UIImage(named: "35")
        gameImage.contentMode = .scaleAspectFill
        gameImage.alpha = 0.1
        
        gameIcon.image = UIImage(named: "League_of_Legends_Icon")
        
        gameNameLabel.textColor = .white
        gameNameLabel.font = UIFont(name: "Roboto-Black", size: 49)
        gameNameLabel.textAlignment = .left
        gameNameLabel.numberOfLines = 3
        gameNameLabel.lineBreakMode = .byTruncatingTail
        gameNameLabel.adjustsFontSizeToFitWidth = true
        gameNameLabel.minimumScaleFactor = 0.1
        
        gameTypeLabel.textColor = .white
        gameTypeLabel.alpha = 0.4
        gameTypeLabel.textAlignment = .left
        gameTypeLabel.font = UIFont(name: "Roboto-Medium", size: 39)
        
        sessionNumberIcon.image = UIImage(named: "gamepad_ic")
        sessionNumberIcon.image = sessionNumberIcon.image!.withRenderingMode(.alwaysTemplate)
        sessionNumberIcon.tintColor = .white
        sessionNumberIcon.alpha = 0.6
        
        sessionNumberLabel.text = "3"
        sessionNumberLabel.textColor = .white
        sessionNumberLabel.alpha = 0.6
        sessionNumberLabel.font = UIFont(name: "Roboto-Regular", size: 30)
        sessionNumberLabel.textAlignment = .left
        
        lastSessionIcon.image = UIImage(named: "clock_ic")
        lastSessionIcon.image = lastSessionIcon.image!.withRenderingMode(.alwaysTemplate)
        lastSessionIcon.tintColor = .white
        lastSessionIcon.alpha = 0.6
        
        lastSessionLabel.text = "Last: 07/11/2017"
        lastSessionLabel.textColor = .white
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
		saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        
        closeButton.setImage(UIImage(named: "close_ic"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
		
		
		levelLabel.text = "Your experience in the game"
		levelLabel.textColor = .white
		//levelLabel.alpha = 0.6
		levelLabel.font = UIFont(name: "Roboto-Regular", size: 15)
		levelLabel.textAlignment = .left
		
		frequencyLabel.text = "Playing days in a week"
		frequencyLabel.textColor = .white
		//frequencyLabel.alpha = 0.6
		frequencyLabel.font = UIFont(name: "Roboto-Regular", size: 15)
		frequencyLabel.textAlignment = .left
		
		pseudoLabel.text = "Your in-game pseudo"
		pseudoLabel.textColor = .white
		//pseudoLabel.alpha = 0.6
		pseudoLabel.font = UIFont(name: "Roboto-Regular", size: 15)
		pseudoLabel.textAlignment = .left

		
		sliderLevel.minimumValue = 0
		sliderLevel.maximumValue = 10
		
		sliderFrequency.minimumValue = 0
		sliderFrequency.maximumValue = 7
		
        pseudoTextField.title = "Pseudo"
        pseudoTextField.selectedTitleColor = .white
        pseudoTextField.selectedLineColor = .white
        pseudoTextField.placeholder = "Pseudo"
        pseudoTextField.textColor = .white
        		
		sliderLevel.addTarget(self, action: #selector(updateLevelLabelValue), for: .valueChanged)
		sliderFrequency.addTarget(self, action: #selector(updateFrequencyLabelValue), for: .valueChanged)
		
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
		
		botContainerView.addSubview(levelLabel)
		botContainerView.addSubview(frequencyLabel)
		botContainerView.addSubview(sliderLevel)
		botContainerView.addSubview(sliderFrequency)
		botContainerView.addSubview(pseudoLabel)
		botContainerView.addSubview(pseudoTextField)
        
        view.addSubview(playButton)
        view.addSubview(saveButton)
        view.addSubview(closeButton)
        
        view.setNeedsUpdateConstraints()
        setNeedsStatusBarAppearanceUpdate()
		
		sliderValueFromDB() { gameParams in //!!!!!!!!!!!!gameParams doit etre set à 0 dans la DB à l'ajout du jeu!!!!!!!!
			self.sliderLevel.value = gameParams.level
			self.sliderFrequency.value = gameParams.frequency
			if (gameParams.pseudo == "0") {
				self.pseudoTextField.placeholder = "Your pseudo here"
			}
			else {
				self.pseudoTextField.text = gameParams.pseudo
			}
			
			self.updateLevelLabelValue()
			self.updateFrequencyLabelValue()
			
		}
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

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
	
	@objc func saveAction() {
		self.ref.child("users/\(user.uid)/gameParam/????GAMEID????/level").setValue(Int(sliderLevel.value))
		self.ref.child("users/\(user.uid)/gameParam/????GAMEID????/frequency").setValue(Int(sliderFrequency.value))
		self.ref.child("users/\(user.uid)/gameParam/????GAMEID????/pseudo").setValue(pseudoTextField.text)
		
		let alertController = UIAlertController(title: "Saved !", message: "Your settings have been saved !", preferredStyle: .alert)
		let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
		alertController.addAction(defaultAction)
		self.present(alertController, animated: true, completion: nil)
	}
	
	func sliderValueFromDB(completion: @escaping (_ data: GameParams) -> Void) {
		ref.child("users/\(user.uid)/gameParam/????GAMEID????/").observe(.value, with: { (snapshot) in
			if let data = snapshot.value as? NSDictionary {
				
				let gameParams = GameParams()
				
				gameParams.level = data["level"] as! Float
				gameParams.frequency = data["frequency"] as! Float
				gameParams.pseudo = data["pseudo"] as! String
				
				completion(gameParams)
			}
		}) { (error) in
			print(error.localizedDescription)
		}
	}
	
    @objc func closeAction() {
        dismiss(animated: true, completion: nil)
    }
	
	@objc func updateLevelLabelValue() {
		let value = String(Int(sliderLevel.value))
		levelLabel.text = "Your experience in the game : \(value)"
	}
	@objc func updateFrequencyLabelValue() {
		let value = String(Int(sliderFrequency.value))
		frequencyLabel.text = "Playing days in a week : \(value)"
		
	func intToLevel(number: Int) -> String {
		if (number == 1) {
			return("Noob")
		}
		else if (number == 2) {
			return("Casual")
		}
		else if (number == 3) {
			return("Middle")
		}
		else if (number == 4) {
			return("Proven")
		}
		else {
			return("Expert")
		}
	}

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
            make.width.equalTo(topContainerView.snp.width).multipliedBy(0.9)
            make.height.equalTo(heightForView(text: gameNameLabel.text!, font: gameNameLabel.font, width: view.frame.width * 0.8))
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
		pseudoLabel.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(botContainerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(30)
			make.centerX.equalTo(botContainerView.snp.centerX)
			make.centerY.equalTo(botContainerView.snp.centerY).offset(-210)
		}
		pseudoTextField.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(botContainerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(30)
			make.centerX.equalTo(botContainerView.snp.centerX)
			make.centerY.equalTo(botContainerView.snp.centerY).offset(-150)
		}
		levelLabel.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(botContainerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(30)
			make.centerX.equalTo(botContainerView.snp.centerX)
			make.centerY.equalTo(botContainerView.snp.centerY).offset(-90)
		}
		sliderLevel.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(botContainerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(30)
			make.centerX.equalTo(botContainerView.snp.centerX)
			make.centerY.equalTo(botContainerView.snp.centerY).offset(-30)
		}
		frequencyLabel.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(botContainerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(30)
			make.centerX.equalTo(botContainerView.snp.centerX)
			make.centerY.equalTo(botContainerView.snp.centerY).offset(30)
		}
		sliderFrequency.snp.makeConstraints { (make) -> Void in
			make.width.equalTo(botContainerView.snp.width).multipliedBy(0.8)
			make.height.equalTo(30)
			make.centerX.equalTo(botContainerView.snp.centerX)
			make.centerY.equalTo(botContainerView.snp.centerY).offset(90)
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

