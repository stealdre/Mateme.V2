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
        
        gameImage.isHidden = true
        gameImage.alpha = 0
        gameImage.image = UIImage(named: "35")
        gameImage.contentMode = .scaleAspectFill
        
        infoLabel.text = "Touch to find a mate"
        infoLabel.textColor = .white
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont(name: "Roboto-Bold", size: 23)
        
        button = CircleMenu(
            frame: CGRect.zero,
            normalIcon:"PlayNowButton_ic",
            selectedIcon:"close_ic",
            buttonsCount: 6,
            duration: 1,
            distance: 200)
        
        button.addTarget(self, action: #selector(playNowButtonTouched), for: .touchUpInside)
        button.backgroundColor = .clear
        button.delegate = self
        
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
        
        view.setNeedsUpdateConstraints()
        
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
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        
        button.backgroundColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
        
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        let gameImage = UIImage(named: "\(arc4random_uniform(30))")
        
        button.setBackgroundImage(gameImage, for: .normal)
        
    }
    
    @objc func playNowButtonTouched(sender: CircleMenu) {
        
        switchButtonState()
        
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
        
        animateLoading(buttonView, button, animate: true)
    }
    
    func animateLoading(_ view: UIView, _ button: UIButton, animate: Bool) {
        
        if animate {
            
            findAMate() // Firebase state setup
            
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
    
    
    
    func showNewMate(mateID: String) {
        
        if roomState.created {
            removeRoom(ref: roomState.createdRef)
        } else if roomState.joined {
            quitRoom(ref: roomState.joinedRef)
        }
        
        self.infoLabel.fadeTransition(0.4)
        self.infoLabel.text = "Matename"
        
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
            
            self.showMateProfile()
            
        })
        
        
        
    }
    
    func showMateProfile() {
        
        self.mateProfilePicture.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState], animations: {() -> Void in
            self.mateProfilePicture.alpha = 1
            
        }, completion: {(_ finished: Bool) -> Void in
            
            self.buttonView.isHidden = true

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
            
            self.mateProfilePicture.layer.add(self.groupAnim, forKey: "anims")
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState], animations: {() -> Void in
                self.mateProfileView.isHidden = false
                self.mateProfileView.alpha = 1
            }, completion: {(_ finished: Bool) -> Void in
                self.mateSessionsValueLabel.countFrom(0, to: 18, withDuration: 3.0)
                self.mateRateValueLabel.countFrom(0, to: 4.7, withDuration: 3.0)
            })
            
        })
        
    }
    
    
    //    func configureResultView() {
    //
    //        resultView.isHidden = false
    //
    //        let rect = self.view.frame
    //
    //        // increases y value
    //        self.yAnim.duration = self.animDuration
    //        self.yAnim.fromValue = self.resultView.frame.origin.y
    //        self.yAnim.toValue = self.resultView.frame.origin.y * 1.45
    //        self.yAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // timing function to make it look nice
    //
    //        // decreases the corner radius
    //        self.cornerRadiusAnim.duration = self.animDuration
    //        self.cornerRadiusAnim.fromValue = self.resultView.layer.cornerRadius
    //        self.cornerRadiusAnim.toValue = 10
    //        self.cornerRadiusAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // timing function to make it look nice
    //
    //        // increases the width
    //        self.widthAnim.duration = self.animDuration
    //        self.widthAnim.fromValue = self.resultView.layer.frame.size.width
    //        self.widthAnim.toValue = rect.size.width * 0.85
    //        self.widthAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // timing function to make it look nice
    //
    //        // increases the height
    //        self.heightAnim.duration = self.animDuration
    //        self.heightAnim.fromValue = self.resultView.layer.frame.size.height
    //        self.heightAnim.toValue = rect.size.height * 0.7
    //        self.heightAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut) // timing function to make it look nice
    //
    //        // adds both animations to a group animation
    //        self.groupAnim.animations = [self.yAnim, self.cornerRadiusAnim, self.widthAnim, self.heightAnim]
    //        self.groupAnim.duration = self.animDuration
    //        self.groupAnim.isRemovedOnCompletion = false
    //        self.groupAnim.fillMode = kCAFillModeForwards
    //
    //        self.resultView.layer.add(self.groupAnim, forKey: "anims")
    //    }
    
    
    
    // 1
    func findAMate() {
        
        roomState.created = false
        roomState.joined = false
        
        mateResearch() { (mateFound, mateID) in
            
            if mateFound {
                print("Room joined with mate: \(mateID)")
                
                self.infoLabel.fadeTransition(0.4)
                self.infoLabel.text = "A mate has been found !"
                self.timeOut(delay: 2) { time in
                    if time {
                        self.showNewMate(mateID: mateID)
                    }
                }
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
    func mateResearch(completion: @escaping (_ mateFound: Bool, _ mateID: String) -> Void) {
        
        checkExistingRooms() { (userFound, usersID) in // Check if some users are looking for a mate (rooms)
            if !userFound { // No room found
                print("There is no player looking for a mate, creating a room...")
                self.createRoom() // Create a room
                completion(false, "")
                return
            } else { // Room found
                print("There are \(usersID.count) rooms available:")
                
                let queue = DispatchGroup()
                
                for user in usersID {
                    queue.enter()
                    print("Try joining room \(user)")
                    
                    self.joinRoom(userID: user) { (roomJoined, mateID) in
                        if roomJoined {
                            completion(true, mateID)
                            return
                        }
                        queue.leave()
                    }
                }
                queue.notify(queue: .main) {
                    print("No free room found")
                    completion(false, "")
                    return
                }
            }
        }
    }
    
    // 3
    func checkExistingRooms(completion: @escaping (_ userFound: Bool, _ usersID: [String]) -> Void) {
        
        let refH = ref.child("matchmaking").child("ALJdXQXEmvoRDf1").child("rooms")
        
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
    func joinRoom(userID: String, completion: @escaping (_ roomJoined: Bool, _ mateID: String) -> Void) {
        
        checkIfRoomIsFree(userId: userID) { isFree in
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
    func checkIfRoomIsFree(userId: String, completion: @escaping (_ isFree: Bool) -> Void) {
        
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
    
    func createRoom() {
        
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
            } else {
                self.infoLabel.fadeTransition(0.4)
                self.infoLabel.text = "No mate found"
                self.timeOut(delay: 2) { time in
                    if time {
                        self.stopSearch()
                    }
                }
            }
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
            make.height.equalTo(buttonView.snp.width)
            make.center.equalTo(view.snp.center)
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
