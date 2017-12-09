//
//  PlayNowViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 22/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit
import CircleMenu
import SwiftSpinner
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import EFCountingLabel


class PlayNowViewController: UIViewController, CircleMenuDelegate {
    
    let yAnim = CABasicAnimation(keyPath: "position.y")
    let alphaAnim = CABasicAnimation(keyPath: "opacity")
    let cornerRadiusAnim = CABasicAnimation(keyPath: "cornerRadius") // the corner radius reducing animation
    let widthAnim = CABasicAnimation(keyPath: "bounds.size.width") // the width animation
    let heightAnim = CABasicAnimation(keyPath: "bounds.size.height")
    let groupAnim = CAAnimationGroup() // the combination of the corner and width animation
    let animDuration = TimeInterval(0.5) // the duration of one 'segment' of the animation
    let layerSize = CGFloat(100) // the width & height of the layer (when it's a square)
    
    
    var recentGames = [String : UIImage]()
    
    var user: User!
    let ref = Database.database().reference()
    private var databaseHandle: DatabaseHandle!
    
    let buttonView = PlayNowButtonView()
    
    let buttonViewIcon = UIImageView()
    
    var button: CircleMenu! = nil
    
    let infoLabel = UILabel()
    
    let gameImage = UIImageView()
    
    let spinnerLoadingView = SpinnerView()
    
    var tapToDismissView = UIView()
    var tapToDismisslabel = UILabel()
    
    var canAnimateButton = true
    var animatingButton = true
    
    var mateProfileView = UIView()
    var mateGameLabel = UILabel()
    var mateProfilePicture = RoundImageView()
    var mateBioLabel = UILabel()
    var mateSessionsLabel = mateStatsLabel()
    var mateSessionsValueLabel = EFCountingLabel()
    var mateRateLabel = mateStatsLabel()
    var mateRateValueLabel = EFCountingLabel()
    var mateSkillLabel = mateStatsLabel()
    var mateSkillValueLabel = mateStatsValueLabel()
    var mateFrequencyLabel = mateStatsLabel()
    var mateFrequencyValueLabel = mateStatsValueLabel()
    
    var mateCall = UIButton()
    var mateSkip = UIButton()
    var mateChat = UIButton()
    
    var mateNumber = String()
    
    struct state {
        var joined = false
        var created = false
        var joinedRef = Database.database().reference().child("nothing")
        var createdRef = Database.database().reference().child("nothing")
    }
    
    var roomState: state!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomState = state(joined: false, created: false, joinedRef: Database.database().reference().child("nothing"), createdRef: Database.database().reference().child("nothing"))
        
        user = Auth.auth().currentUser
        
        getRecentGames() { games in
            
            var gamesNumber = 0
            
            self.recentGames = games
            
            self.button.isEnabled = true
            
            if games.count <= 6 {
                gamesNumber = games.count
            } else {
                gamesNumber = 6
            }
            
            self.button = CircleMenu(
                frame: CGRect.zero,
                normalIcon:"PlayNowButton_ic",
                selectedIcon:"close_ic",
                buttonsCount: gamesNumber,
                duration: 1,
                distance: 200)
            
            self.button.addTarget(self, action: #selector(self.playNowButtonTouched), for: .touchUpInside)
            self.button.backgroundColor = .clear
            self.button.delegate = self
        }
        
        button.isEnabled = false
        
        gameImage.isHidden = true
        gameImage.alpha = 0
        gameImage.image = UIImage(named: "35")
        gameImage.contentMode = .scaleAspectFill
        
        infoLabel.text = "Touch to find a mate"
        infoLabel.textColor = .white
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont(name: "Roboto-Bold", size: 23)
        
        spinnerLoadingView.isHidden = true
        spinnerLoadingView.alpha = 0
        
        tapToDismissView.backgroundColor = .clear
        tapToDismissView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action:  #selector(stopSearch))
        tapToDismissView.addGestureRecognizer(tap)
        
        tapToDismisslabel.text = "Tap to cancel"
        tapToDismisslabel.textColor = .white
        tapToDismisslabel.alpha = 0
        tapToDismisslabel.textAlignment = .center
        tapToDismisslabel.font = UIFont(name: "Roboto-Medium", size: 16)
        
        mateProfilePicture.isHidden = true
        mateProfilePicture.image = UIImage(named: "35")
        mateProfilePicture.alpha = 0
        
        mateProfileView.isHidden = true
        mateProfileView.alpha = 0
        
        mateGameLabel.text = "League of Legends"
        mateGameLabel.textColor = .white
        mateGameLabel.alpha = 0.7
        mateGameLabel.textAlignment = .center
        mateGameLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        
        mateBioLabel.text = "Bio dbzdj bzad: bad:lazbdaz=mdja:zlfih filaeg feiulf hazufgaz fug afiaeg fkaeg fm alf."
        mateBioLabel.textColor = .white
        mateBioLabel.alpha = 1
        mateBioLabel.textAlignment = .center
        mateBioLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        mateBioLabel.numberOfLines = 5
        mateBioLabel.lineBreakMode = .byTruncatingTail
        mateBioLabel.adjustsFontSizeToFitWidth = true
        mateBioLabel.minimumScaleFactor = 0.1
        mateBioLabel.alpha = 0.8
        
        mateGameLabel.text = "League of Legends"
        mateGameLabel.textColor = .white
        mateGameLabel.alpha = 0.7
        mateGameLabel.textAlignment = .center
        mateGameLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        
        mateSessionsLabel.text = "Sessions"
        mateSessionsValueLabel = EFCountingLabel(frame: CGRect(x: 10, y: 10, width: 200, height: 40))
        mateSessionsValueLabel.method = .easeOut
        mateSessionsValueLabel.format = "%d"
        mateSessionsValueLabel.font = UIFont(name: "Roboto-Bold", size: 40)
        mateSessionsValueLabel.textColor = .white
        
        mateRateLabel.text = "Rate"
        mateRateValueLabel = EFCountingLabel(frame: CGRect(x: 10, y: 10, width: 200, height: 40))
        mateRateValueLabel.method = .easeOut
        mateRateValueLabel.format = "%.1f"
        mateRateValueLabel.font = UIFont(name: "Roboto-Bold", size: 40)
        mateRateValueLabel.textColor = .white
        
        mateSkillLabel.text = "Skill"
        mateSkillValueLabel.text = "Noob"
        mateFrequencyLabel.text = "Frequency"
        mateFrequencyValueLabel.text = "Casual"
        
        mateCall.setBackgroundImage(UIImage(named: "call_ic"), for: .normal)
        mateCall.addTarget(self, action: #selector(facetime), for: .touchUpInside)
        
        mateSkip.setBackgroundImage(UIImage(named: "skipMate_ic"), for: .normal)
        mateSkip.addTarget(self, action: #selector(skipMate), for: .touchUpInside)
        
        view.addSubview(gameImage)
        view.addSubview(infoLabel)
        view.addSubview(buttonView)
        view.addSubview(mateProfilePicture)
        view.addSubview(spinnerLoadingView)
        view.addSubview(button)
        view.addSubview(tapToDismissView)
        tapToDismissView.addSubview(tapToDismisslabel)
        
        view.addSubview(mateProfileView)
        mateProfileView.addSubview(mateGameLabel)
        mateProfileView.addSubview(mateBioLabel)
        mateProfileView.addSubview(mateSessionsLabel)
        mateProfileView.addSubview(mateSessionsValueLabel)
        mateProfileView.addSubview(mateRateLabel)
        mateProfileView.addSubview(mateRateValueLabel)
        mateProfileView.addSubview(mateSkillLabel)
        mateProfileView.addSubview(mateSkillValueLabel)
        mateProfileView.addSubview(mateFrequencyLabel)
        mateProfileView.addSubview(mateFrequencyValueLabel)
        mateProfileView.addSubview(mateCall)
        mateProfileView.addSubview(mateSkip)
        
        view.setNeedsUpdateConstraints()
        
        
        /*
         // upload games
         
         let games = ["Absolver", "Assassin Screed Untity", "Batllerite", "Borderlands 2", "Call of Duty WW2", "Counter Strike Source", "Dragon Ball Xenoverse 2", "Evolve", "Fallout 4", "Far Cry Primal", "Far Cry 4", "Far Cry 5", "FIFA 18", "Final Fantasy 15", "Fortnite", "GTA V", "H1z1", "Half life 2", "Halo 5", "Heroes of storm", "Hitman", "League of Legends", "Minecraft", "Watchdogs", "Trine 2", "Star Wars Batllefront 2", "Rocket League", "Rainbow six siege", "Portal 2", "Paragon", "Overwatch", "Overlord"]
         
         for game in games {
         let uid = UUID().uuidString
         ref.child("games").child(uid).child("name").setValue(game)
         ref.child("games").child(uid).child("type").setValue(" ")
         ref.child("games").child(uid).child("imagePath").setValue(" ")
         ref.child("games").child(uid).child("description").setValue(" ")
         }
         
         */
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateButton(buttonView, self.button, animate: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.buttonView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.button.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        stopSearch()
    }
    
    func getRecentGames(completion: @escaping (_ games: [String : UIImage]) -> Void) {
        
        var recentGamesData = [String : UIImage]()
        
        ref.child("users").child(user.uid).child("games").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let games = snapshot.value as? [String : AnyObject] {
                for game in games {
                    self.getGameInfo(ID: game.key) { info in
                        self.getGameImage(url: info.imageURL) { image in
                            recentGamesData[game.key] = image
                        }
                    }
                }
                completion(recentGamesData)
            }
        })
    }
    
    func getGameInfo(ID: String, completion: @escaping (_ game: Games) -> Void) {
        
        let ref = Database.database().reference()
        
        ref.child("games").child(ID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                
                let game = Games()
                
                game.name = data["name"]! as! String
                game.imageURL = data["imagePath"]! as! String
                
                completion(game)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getGameImage(url: String, completion: @escaping (_ image: UIImage) -> Void) {
        
        let storage = Storage.storage()
        
        let pathReference = storage.reference(withPath: url)
        
        pathReference.getData(maxSize: 1 * 5000 * 5000) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                if image != nil {
                    completion(image!)
                }
            }
        }
    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        
        button.backgroundColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
        
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        
        let key = Array(recentGames.keys)[atIndex]
        let gameImage = recentGames[key]
        
        button.setBackgroundImage(gameImage, for: .normal)
    }
    
    @objc func playNowButtonTouched(sender: CircleMenu) {
        
        switchButtonState()
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        
        print("button did selected: \(atIndex)")
        
        animateLoading(buttonView, button, animate: true)
        
        let key = Array(recentGames.keys)[atIndex]
        
        findAMate(gameID: key) // Firebase mate search
    }
    
    func animateLoading(_ view: UIView, _ button: UIButton, animate: Bool) {
        
        if animate {
            
            tapToDismissView.isHidden = false
            
            self.infoLabel.fadeTransition(0.4)
            self.infoLabel.text = "Looking for a mate"
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState , .curveEaseInOut], animations: {() -> Void in
                
                view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                
                self.infoLabel.frame.origin.y += self.view.frame.height * 0.12
                self.infoLabel.snp.remakeConstraints {(make) -> Void in
                    make.width.equalTo(self.view.snp.width).multipliedBy(0.9)
                    make.height.equalTo(30)
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.centerY.equalTo(self.view.snp.centerY).offset(-150)
                }
                
                self.tapToDismisslabel.alpha = 0.5
                self.gameImage.isHidden = false
                self.gameImage.alpha = 0.05
                
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {() -> Void in
                    self.spinnerLoadingView.isHidden = false
                    self.spinnerLoadingView.alpha = 1
                })
            })
        }
    }
    
    func switchButtonState() {
        
        if !animatingButton { // start animating
            
            if buttonView.transform.a == 0.7 {
                UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
                    self.buttonView.transform = CGAffineTransform.identity
                    self.button.transform = CGAffineTransform.identity
                    self.infoLabel.fadeTransition(0.2)
                    self.infoLabel.text = "Touch to find a mate"
                    self.infoLabel.frame.origin.y += self.view.frame.height * 0.12
                    self.infoLabel.snp.remakeConstraints {(make) -> Void in
                        make.width.equalTo(self.view.snp.width).multipliedBy(0.9)
                        make.height.equalTo(30)
                        make.centerX.equalTo(self.view.snp.centerX)
                        make.centerY.equalTo(self.view.snp.centerY).offset(-150)
                    }
                }, completion: {(_ finished: Bool) -> Void in
                    self.animateButton(self.buttonView, self.button, animate: true)
                })
            } else {
                self.animateButton(self.buttonView, self.button, animate: true) // First animation start
            }
        } else { // stop animating : game selection
            UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
                self.infoLabel.frame.origin.y -= self.view.frame.height * 0.12
                self.infoLabel.snp.remakeConstraints {(make) -> Void in
                    make.width.equalTo(self.view.snp.width).multipliedBy(0.9)
                    make.height.equalTo(30)
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.centerY.equalTo(self.view.snp.centerY).offset(-150 - self.view.frame.height * 0.12)
                }
            })
            self.infoLabel.fadeTransition(0.2)
            self.infoLabel.text = "Select a game"
            self.animateButton(self.buttonView, self.button, animate: false)
        }
    }
    
    func animateButton(_ view: UIView, _ button: UIButton, animate: Bool) {
        if animate {
            animatingButton = true
            UIView.animate(withDuration: 3.0, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction, .beginFromCurrentState], animations: {
                view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                button.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
        } else {
            animatingButton = false
            self.buttonView.layer.removeAllAnimations()
            self.button.layer.removeAllAnimations()
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                button.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
        }
    }
    
    @objc func stopSearch() {
        
        if roomState.created {
            removeRoom(ref: roomState.createdRef)
        } else if roomState.joined {
            quitRoom(ref: roomState.joinedRef)
        }
        
        self.infoLabel.fadeTransition(0.4)
        self.infoLabel.text = "Touch to find a mate"
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction], animations: {() -> Void in
            self.spinnerLoadingView.alpha = 0
            self.gameImage.alpha = 0
            self.tapToDismisslabel.alpha = 0
            self.buttonView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.button.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: {(_ finished: Bool) -> Void in
            self.spinnerLoadingView.isHidden = true
            self.gameImage.isHidden = true
            self.tapToDismissView.isHidden = true
            self.animateButton(self.buttonView, self.button, animate: true)
        })
    }
    
}

// MARK: Firebase
extension PlayNowViewController {
    
    func getUserInfosFrom(id: String, game: String, completion: @escaping(
        _ name: String,
        _ profilePic: UIImage,
        _ bio: String,
        _ rate: Double,
        _ frequency: Int,
        _ level: Int,
        _ sessionNumber: Int ) -> Void) {
        
        let newRef = ref.child("users").child(id)
        
        var name = ""
        var profilePicture = UIImage()
        var bio = ""
        var rate = 0.0
        var frequency = 0
        var level = 0
        var sessionNumber = 0
        
        newRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                if let data = snapshot.value as? [String : AnyObject] {
                    
                    if let value = data["rate"] as? Double,
                        let pseudo = data["name"] as? String,
                        let phone = data["phoneNumber"] as? String {
                        
                        self.mateNumber = phone
                        rate = value
                        name = pseudo
                        
                        if let imagePath = data["profilPicPath"] as? String {
                            
                            let storage = Storage.storage()
                            let pathReference = storage.reference(withPath: imagePath)
                            
                            pathReference.getData(maxSize: 1 * 5000 * 5000) { imageData, error1 in
                                if let error = error1 {
                                    print(error)
                                } else {
                                    
                                    profilePicture = UIImage(data: imageData!)!
                                    
                                    if let history = data["history"] as? [String : AnyObject] {
                                        sessionNumber = history.count
                                        newRef.child("gameParam").child(game).observeSingleEvent(of: .value, with: { (snapshot) in
                                            if let parameters = snapshot.value as? [String : Int] {
                                                frequency = Int(parameters["frequency"]!)
                                                level = Int(parameters["level"]!)
                                                
                                                if let bioValue = data["bio"] as? String {
                                                    bio = bioValue
                                                } else {
                                                    bio = ""
                                                }
                                                completion(name, profilePicture, bio, rate, frequency, level, sessionNumber)
                                            }
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func showNewMate(mateID: String) {
        
        getUserInfosFrom(id: mateID, game: "ALJdXQXEmvoRDf1") { (name, profilePic, bio, rate, frequency, level, sessionNumber) in
            
            self.infoLabel.fadeTransition(0.4)
            self.infoLabel.text = name
            
            self.mateBioLabel.text = bio
            self.mateProfilePicture.image = profilePic
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState], animations: {() -> Void in
                
                self.spinnerLoadingView.alpha = 0
                self.button.alpha = 0
                self.tapToDismisslabel.alpha = 0
                
                self.buttonView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.button.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                self.infoLabel.frame.origin.y -= self.view.frame.height * 0.12
                self.infoLabel.snp.remakeConstraints {(make) -> Void in
                    make.width.equalTo(self.view.snp.width).multipliedBy(0.9)
                    make.height.equalTo(30)
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.centerY.equalTo(self.view.snp.centerY).offset(-150 - self.view.frame.height * 0.12)
                }
            }, completion: {(_ finished: Bool) -> Void in
                
                self.spinnerLoadingView.isHidden = true
                self.tapToDismissView.isHidden = true
                
                self.showMateProfile(rate: rate, frequency: frequency, level: level, sessions: sessionNumber)
                
            })
            
        }
    }
    
    func showMateProfile(rate: Double, frequency: Int, level: Int, sessions: Int) {
        
        self.mateProfilePicture.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState], animations: {() -> Void in
            self.mateProfilePicture.alpha = 1
            
        }, completion: {(_ finished: Bool) -> Void in
            
            self.buttonView.isHidden = true
            
            //            self.mateProfilePicture.snp.remakeConstraints { (make) -> Void in
            //                make.width.equalTo(150)
            //                make.height.equalTo(150)
            //                make.centerX.equalTo(self.view.snp.centerX)
            //                make.top.equalTo(self.mateProfilePicture.frame.origin.y * 0.93)
            //            }
            
            // increases y value
            self.yAnim.duration = self.animDuration
            self.yAnim.fromValue = self.mateProfilePicture.frame.origin.y
            self.yAnim.toValue = self.mateProfilePicture.frame.origin.y * 0.93
            self.yAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // timing function to make it look nice
            
            
            // adds both animations to a group animation
            self.groupAnim.animations = [self.yAnim]
            self.groupAnim.duration = self.animDuration
            self.groupAnim.isRemovedOnCompletion = false
            self.groupAnim.fillMode = kCAFillModeForwards
            
            //self.mateProfilePicture.layer.add(self.groupAnim, forKey: "anims")
            
            
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState], animations: {() -> Void in
                self.mateProfilePicture.frame.origin.y = self.mateProfilePicture.frame.origin.y * 0.7
                self.mateProfileView.isHidden = false
                self.mateProfileView.alpha = 1
                self.mateBioLabel.alpha = 1
            }, completion: {(_ finished: Bool) -> Void in
                self.mateSessionsValueLabel.countFrom(0, to: CGFloat(sessions), withDuration: 2.0)
                self.mateRateValueLabel.countFrom(0, to: CGFloat(rate), withDuration: 2.0)
            })
        })
    }
    
    // 1
    func findAMate(gameID: String) {
        
        roomState.created = false
        roomState.joined = false
        roomState.createdRef = Database.database().reference().child("nothing")
        roomState.joinedRef = Database.database().reference().child("nothing")
        
        mateResearch(gameID: gameID) { (mateFound, mateID) in
            
            if mateFound {
                print("Room joined with mate: \(mateID)")
                
                self.infoLabel.fadeTransition(0.4)
                self.infoLabel.text = "A mate has been found !"
                
                self.showNewMate(mateID: mateID)
                
            } else {
                print("No mate found")
                
                self.infoLabel.fadeTransition(0.4)
                self.infoLabel.text = "No mate found !"
                self.timeOut(delay: 2) { time in
                    if time {
                        self.stopSearch()
                    }
                }
            }
        }
    }
    // 2
    func mateResearch(gameID: String, completion: @escaping (_ mateFound: Bool, _ mateID: String) -> Void) {
        
        checkExistingRooms(gameID: gameID) { (userFound, usersID) in // Check if some users are looking for a mate (rooms)
            if !userFound { // No room found
                print("There is no player looking for a mate, creating a room...")
                self.createRoom(gameID: gameID) { (answer, id) in
                    if !answer {
                        completion(false, id)
                    } else {
                        completion(true, id)
                    }
                }
                return
            } else { // Room found
                print("There are \(usersID.count) rooms available:")
                
                let queue = DispatchGroup()
                
                for user in usersID {
                    queue.enter()
                    print("Try joining room \(user)")
                    
                    self.joinRoom(gameID: gameID, userID: user) { (roomJoined, mateID) in
                        if roomJoined {
                            completion(true, mateID)
                            return
                        }
                        queue.leave()
                    }
                }
                queue.notify(queue: .main) {
                    print("No free room found")
                    if !self.roomState.joined {
                        self.createRoom(gameID: gameID) { (answer, id) in
                            if answer {
                                completion(true, id)
                                return
                            } else {
                                completion(false, "")
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    // 3
    func checkExistingRooms(gameID: String, completion: @escaping (_ userFound: Bool, _ usersID: [String]) -> Void) {
        
        let refH = ref.child("matchmaking").child(gameID).child("rooms")
        
        refH.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let users = snapshot.value as? NSDictionary {
                
                let arr = users as! [String : AnyObject]
                
                if arr.isEmpty {
                    completion(false, [""]) // No user
                    return
                } else {
                    var usersID = [String]()
                    for user in users {
                        let id = String(describing: user.key)
                        usersID.append(id)
                    }
                    completion(true, usersID) // One user or more
                    return
                }
            }
        })
    }
    
    // 4
    func joinRoom(gameID: String, userID: String, completion: @escaping (_ roomJoined: Bool, _ mateID: String) -> Void) {
        
        checkIfRoomIsFree(gameID: gameID, userId: userID) { isFree in
            if isFree {
                
                //checkIfPlayersMatch() { isMatching in
                
                print("Found a free room, awaiting for the other player to accept...")
                
                let newRef = self.ref.child("matchmaking").child("ALJdXQXEmvoRDf1").child("rooms").child(userID)
                newRef.setValue(1)
                newRef.child(self.user.uid).setValue(0)
                
                self.roomState.joined = true
                self.roomState.joinedRef = newRef
                
                self.waitingForAnswer(ref: newRef) { response in
                    if response {
                        completion(true, userID)
                        return
                    } else {
                        completion(false, "")
                        return
                    }
                }
                //}
            } else {
                completion(false, "")
                return
            }
        }
    }
    
    //5
    func checkIfRoomIsFree(gameID: String, userId: String, completion: @escaping (_ isFree: Bool) -> Void) {
        
        let refH = ref.child("matchmaking").child("ALJdXQXEmvoRDf1").child("rooms").child(userId)
        
        refH.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Int {
                if value == 0 {
                    completion(true)
                    return
                } else {
                    completion(false)
                    return
                }
            }
        })
    }
    
    // 6
    func waitingForAnswer(ref: DatabaseReference, completion: @escaping (_ answer: Bool) -> Void) {
        
        var handle: UInt = 0
        
        var ret = true
        
        handle = ref.child(self.user.uid).observe(.value, with: { (snapshot) in
            
            if let value = snapshot.value as? Int {
                if value == 0 { // No response
                    
                } else { // Response
                    ret = false
                    ref.removeObserver(withHandle: handle)
                    completion(true)
                    return
                }
            }
        })
        
        let when = DispatchTime.now() + 15  // Int(delay) secondes time out
        DispatchQueue.main.asyncAfter(deadline: when) {
            if ret {
                ref.removeObserver(withHandle: handle)
                self.quitRoom(ref: ref)
                completion(false)
                return
            }
        }
    }
    
    func waitingForPlayer(ref: DatabaseReference, completion: @escaping (_ answer: Bool, _ userId: String) -> Void) {
        
        var handle: UInt = 0
        
        var ret = true
        
        handle = ref.observe(.value, with: { (snapshot) in
            
            if let value = snapshot.value as? [String : Int] {
                
                ret = false
                
                let newMateId = value.keys.first
                
                ref.child(newMateId!).setValue(1)
                ref.removeObserver(withHandle: handle)
                
                completion(true, newMateId!)
                return
                
            } else { // waiting
                
                print("Waiting for a mate to join...")
            }
        })
        
        let when = DispatchTime.now() + 15 // Int(delay) secondes time out
        DispatchQueue.main.asyncAfter(deadline: when) {
            if ret {
                ref.removeObserver(withHandle: handle)
                self.removeRoom(ref: ref)
                completion(false, "")
                return
            }
        }
        
    }
    
    func createRoom(gameID: String, completion: @escaping (_ answer: Bool, _ userId: String) -> Void) {
        
        let newRef = ref.child("matchmaking").child("ALJdXQXEmvoRDf1").child("rooms").child(user.uid)
        newRef.setValue(0)
        
        roomState.created = true
        roomState.createdRef = newRef
        
        waitingForPlayer(ref: newRef) { (answer, mateId) in
            if answer {
                self.infoLabel.fadeTransition(0.4)
                self.infoLabel.text = "Your mate has been found"
                print("Linking users...")
                print("Mate: \(mateId)")
                completion(true, mateId)
                return
            } else {
                self.infoLabel.fadeTransition(0.4)
                self.infoLabel.text = "No mate found"
                self.timeOut(delay: 2) { time in
                    if time {
                        self.stopSearch()
                        completion(false, "")
                        return
                    }
                }
            }
        }
    }
    
    @objc func skipMate() {
        
        if roomState.joined {
            quitRoom(ref: roomState.joinedRef)
        } else if roomState.created {
            removeRoom(ref: roomState.createdRef)
        }
    }
    
    func removeRoom(ref: DatabaseReference) {
        ref.removeValue()
    }
    
    func quitRoom(ref: DatabaseReference) {
        ref.setValue(0)
    }
    
    func timeOut(delay:Double, completion: @escaping (_ timeOut: Bool) -> Void) {
        let when = DispatchTime.now() + delay // Int(delay) secondes time out
        DispatchQueue.main.asyncAfter(deadline: when) {
            completion(true)
        }
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
    
    @objc func facetime() {
        
        if let facetimeURL:NSURL = NSURL(string: "facetime://\(self.mateNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(facetimeURL as URL)) {
                application.openURL(facetimeURL as URL)
            }
        }
    }
    
}

// MARK: Constraints
extension PlayNowViewController {
    
    override func updateViewConstraints() {
        
        gameImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.center.equalTo(view.snp.center)
        }
        infoLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(30)
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(-150)
        }
        buttonView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(buttonView.snp.width)
            make.center.equalTo(view.snp.center)
        }
        button.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(button.snp.width)
            make.center.equalTo(view.snp.center)
        }
        spinnerLoadingView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(buttonView.snp.width).multipliedBy(1.35)//.offset(-spinnerLoadingView.layer.lineWidth)
            make.height.equalTo(spinnerLoadingView.snp.width)
            make.center.equalTo(buttonView.snp.center)
        }
        tapToDismissView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height)
            make.center.equalTo(view.snp.center)
        }
        tapToDismisslabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(tapToDismissView.snp.width).multipliedBy(0.8)
            make.height.equalTo(20)
            make.centerX.equalTo(tapToDismissView.snp.centerX)
            make.bottom.equalTo(tapToDismissView.snp.bottom).offset(-120)
        }
        mateProfilePicture.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(150)
            make.height.equalTo(mateProfilePicture.snp.width)
            make.centerY.equalTo(view.snp.centerY)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        makeMateProfileConstraints()
        
        super.updateViewConstraints()
    }
    
    func makeMateProfileConstraints() {
        
        mateProfileView.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.85)
            make.height.equalTo(view.snp.height).multipliedBy(0.7)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
        }
        mateGameLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(mateProfileView.snp.width).multipliedBy(0.7)
            make.height.equalTo(21)
            make.centerX.equalTo(mateProfileView.snp.centerX)
            make.top.equalTo(mateProfileView.snp.top)
        }
        mateBioLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(mateProfileView.snp.width).multipliedBy(0.9)
            make.height.equalTo(heightForView(text: mateBioLabel.text!, font: mateBioLabel.font, width: view.frame.width * 0.8))
            make.centerX.equalTo(mateProfileView.snp.centerX)
            make.top.equalTo(mateGameLabel.snp.bottom).offset(150 + 40)
        }
        mateSessionsLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(mateProfileView.snp.width).multipliedBy(0.3)
            make.height.equalTo(21)
            make.left.equalTo(mateProfileView.snp.left).offset(20)
            make.top.equalTo(mateBioLabel.snp.bottom).offset(25)
        }
        mateSessionsValueLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(mateProfileView.snp.width).multipliedBy(0.3)
            make.height.equalTo(42)
            make.left.equalTo(mateProfileView.snp.left).offset(20)
            make.top.equalTo(mateSessionsLabel.snp.bottom).offset(2)
        }
        mateRateLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(mateProfileView.snp.width).multipliedBy(0.3)
            make.height.equalTo(21)
            make.left.equalTo(mateSessionsLabel.snp.right).offset(50)
            make.top.equalTo(mateSessionsLabel.snp.top)
        }
        mateRateValueLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(mateProfileView.snp.width).multipliedBy(0.4)
            make.height.equalTo(42)
            make.left.equalTo(mateRateLabel.snp.left)
            make.top.equalTo(mateRateLabel.snp.bottom).offset(2)
        }
        mateSkillLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(mateProfileView.snp.width).multipliedBy(0.3)
            make.height.equalTo(21)
            make.left.equalTo(mateProfileView.snp.left).offset(20)
            make.top.equalTo(mateRateValueLabel.snp.bottom).offset(20)
        }
        mateSkillValueLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(mateProfileView.snp.width).multipliedBy(0.4)
            make.height.equalTo(42)
            make.left.equalTo(mateProfileView.snp.left).offset(20)
            make.top.equalTo(mateSkillLabel.snp.bottom).offset(2)
        }
        mateFrequencyLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(mateProfileView.snp.width).multipliedBy(0.3)
            make.height.equalTo(21)
            make.left.equalTo(mateSkillLabel.snp.right).offset(50)
            make.top.equalTo(mateSkillLabel.snp.top)
        }
        mateFrequencyValueLabel.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(mateProfileView.snp.width).multipliedBy(0.4)
            make.height.equalTo(42)
            make.left.equalTo(mateFrequencyLabel.snp.left)
            make.top.equalTo(mateFrequencyLabel.snp.bottom).offset(2)
        }
        mateCall.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(mateProfileView.snp.centerX)
            make.bottom.equalTo(mateProfileView.snp.bottom).offset(-25)
        }
        mateSkip.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.right.equalTo(mateCall.snp.left).offset(-35)
            make.bottom.equalTo(mateCall.snp.bottom)
        }
    }
}

class mateStatsLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.font = UIFont(name: "Roboto-Bold", size: 20)
        self.textColor = .white
        self.alpha = 0.7
    }
    
}

class mateStatsValueLabel: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.font = UIFont(name: "Roboto-Bold", size: 40)
        self.textColor = .white
    }
    
}
