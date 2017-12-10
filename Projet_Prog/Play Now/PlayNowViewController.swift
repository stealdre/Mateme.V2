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
    
    
    var recentGames = [String : [UIImage]]()
    
    var user: User!
    let ref = Database.database().reference()
    private var databaseHandle: DatabaseHandle!

    var mateID = ""
    
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
    
    var selectedGame = 0
    
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
            self.button.buttonsCount = gamesNumber
            self.button.addTarget(self, action: #selector(self.playNowButtonTouched), for: .touchUpInside)
        }
        
        self.button = CircleMenu(
            frame: CGRect.zero,
            normalIcon: "PlayNowButton_ic",
            selectedIcon: "close_ic",
            buttonsCount: 0,
            duration: 1,
            distance: 200)
        
        self.button.delegate = self
        self.button.backgroundColor = .clear
        
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
        
        
        mateChat.setBackgroundImage(UIImage(named: "mateChat_ic"), for: .normal)
        mateSkip.addTarget(self, action: #selector(chatMate), for: .touchUpInside)
        
        
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
        mateProfileView.addSubview(mateChat)
        
        view.setNeedsUpdateConstraints()
        
         /*
         let games = ["Absolver", "Assassin Screed Untity", "Batllerite", "Borderlands 2", "Call of Duty WW2", "Counter Strike Source", "Dragon Ball Xenoverse 2", "Evolve", "Fallout 4", "Far Cry Primal", "Far Cry 4", "Far Cry 5", "FIFA 18", "Final Fantasy 15", "Fortnite", "GTA V", "H1z1", "Half life 2", "Halo 5", "Heroes of storm", "Hitman", "League of Legends", "Minecraft", "Overlord", "Overwatch", "Paragon", "Portal 2", "Rainbow six siege", "Rocket League", "Star Wars Batllefront 2", "Trine 2", "Watchdogs"]
        
        let type = ["Action-RPG", "Infiltration", "MOBA", "Action-RPG", "FPS", "FPS", "Fight", "FPS", "Action-RPG", "Action-Adventure", "Action-adventure", "Action-Adventure", "Sport", "Action-RPG", "FPS", "Action-Adventure", "Survival", "FPS", "FPS", "MOBA", "Infiltration", "MOBA", "Creation", "Action", "MMO", "MOBA", "FPS", "FPS", "Action-Sport", "FPS", "Action", "Action-Adventure"]
        
        let imagePath = ["Dans ce jeu d'action en ligne, les Aspirants parcourent le monde et se croisent pour décider de collaborer contre l'environnement ou de combattre. Les attaques ainsi que les pouvoirs sont variéeset chaque participant peut trouver son style, jusqu'à devenir un Absolver.", "Assassin's Creed Unity est un jeu d'action / aventure sur PC. Cet épisode vous place dans la peau d'Arno Dorian, un jeune Assassin officiant à Paris en pleine Révolution française.", "Battlerite sur PC est un jeu de combat par équipe dans une arène. Découvrez l'association jeu de tir et jeu de combat. Défiez vos amis et d'autres joueurs dans une bataille qui mettra votre réactivité à l'épreuve, révélant ainsi le champion qui est en vous.", "Borderlands 2 sur PC est un mélange de jeu de tir à la première personne et de jeu de rôle. Le joueur doit s'aventurer dans les mondes inexplorés de Pandora et percer les secrets de l'univers de Borderlands.", "Pour cet opus, les développeurs ont opéré un retour aux sources de la saga en traitant la période historique de la Seconde Guerre mondiale.", "Le jeu permet au joueur de choisir son camp entre les terroristes et les contre-terroristes. Plusieurs objectifs différents en fonction du camp adopté et de la carte choisie doivent être menées à bien afin de remporter la partie.", "Un an après le premier Opus, Dragon Ball Xenoverse revient dans un nouveau jeu qui revendique l'univers le plus détaillé de tous les jeux Dragon Ball.", "Une équipe de quatre chasseurs répartis en quatre classes affrontent un monstre dans une grande zone. Le monstre peut évoluer en mangeant des créatures de la faune locale.", "Dans un monde dévasté par les bombes, vous incarnez un personnage solitaire sortant d'un abri anti-atomique qui doit se faire sa place dans la ville de Boston et de ses environs.", "Dans Far Cry Primal, vous incarnez Takkar, dernier survivant de son groupe de chasseurs, devant survivre seul dans un monde préhistorique. Pour cela, il va falloir former sa tribu, créer des alliances avec d'autres personnages...", "Le joueur incarne Ajay, il prend part à la rébellion pour le soulèvement de son pays face au dictateur Pagan Min. Le titre offre une aventure solo en monde ouvert que l'on peut aussi explorer en coopération à deux.", "Bienvenue à Hope County dans le Montana, terre de liberté et de bravoure qui abrite un culte fanatique prêchant la fin du monde : Eden’s Gate. Défiez son chef, Joseph Seed, et ses frères et soeur, et libérez les citoyens.", "Un fifa moderne : Le championnat chinois fait son apparition pour la première fois, sans oublier les traditionnelles améliorations apportées aux graphismes et au gameplay, ainsi que le retour de Pierre Ménès et Hervé Mathoux aux commentaires.", "Le joueur y suit les aventures de Noctis, un jeune homme taciturne et héritier du trône. Il voyagera avec ses compagnons dans un monde à la fois moderne et fantastique.", "Les joueurs se réunissent en équipe et doivent crafter armes et pièges pour ensuite construire une forteresse et la défendre contre les nombreux monstres qui viendront l'assaillir.", "L'histoire du jeu se déroulera à Los Santos,une ville inspirée de Los Angeles et l'on pourra visiblement incarner plusieurs personnages.", "Ici il faut survivre au milieu d'une infection de zombies causée par le virus H1Z1. Le joueur doit s'allier ou lutteravec les autres personnes présentes sur le serveur pour survivre au jour le jour.", "Vous incarnez le professeur Gordon Freeman, fraîchement arrivé dans une ville aux mains d'une mystérieuse organisation appelée Le Cartel. Le joueur va devoir s'échapper de la ville et traquer le chef de la propagande.", "Mettant en scène les aventures du Master Chief et d'un nouveau personnage, le jeu dispose d'une importante partie multijoueur et reprend les modes de jeu connus de la série.", "Deux équipes de cinq joueurs s'affrontent dans des parties qui durent sur un temps assez court, aux alentours de20 minutes. Le principe de base est simple : Vous sélectionnez votre héros mais vous ne pouvez pas choisir la carte sur laquelle vous allez jouer.", "Le joueur y incarne l'Agent 47 le célèbre tueur à gages. L'objectif est de remplir des contrats en éliminant des cibles aussi puissantes que célèbres dans des lieux exotiques à travers tout le globe.", "Il s'agit d'un jeu de stratégie présentant plusieurs héros (assassins, mages ou encore créatures du néant...) que vous devrez protéger pour décrocher la victoire dans un univers fantastique coloré.", "Jeu bac à sable indépendant et pixelisé dont le monde infini est généré aléatoirement, Minecraft permet au joueur de récolter divers matériaux, d'élever des animaux et de modifier le terrain selon ses choix, en solo ou en multi.", "Dans ce jeu d'action à la 3ème personne, incarnez un soldat des Enfers, l'Overlord,accompagné d'une armée de larbins démoniaques à qui vous allez assigner le maximum de tâches : combattre, piller et détruire à votre place !", "Dans des parties en 6 contre 6, le joueur incarne un héros parmi la paletteproposée. Chaque personnage a des caractéristiques et des capacités particulières et un rôle défini parmi Attaque, Défense, Tank et Soutien.", "Celui-ci vous immerge au cœur de l'action des combats explosifs. Il offre aux joueurs une bonne maîtrise de son champion et permet ainsi à chacun d'adopter la meilleure composition de personnages pour établir une stratégie.", "Shell, l’héroïne, doit une fois de plus essayer de s'échapper du complexe d'Aperture Science en utilisant le Portal Gun, sorte de pistolet permettant de créer des portails.", "Jeu d'action tactique appartenant à la fameuse série du même nom. Cet épisode est principalement axé sur le multijoueur et l'importance du jeu en équipe, avec des environnements facilement destructibles.", "Rocket League vous plonge dans des matchs d'arène où votre but sera de marquer des buts. Vous pourrez mettre au point différentestactiques, soit éviter les attaques des joueurs ennemis pour aller marquer, soit démolir la défense.", "Le titre vous permet de prendre part à des combats sur Terre ou dans les airs dans les lieux emblématiquesdes films. Rejoignez les rangs de l'Empire ou ceux de la Rébellion dans des parties multijoueur.", "Dans un royaume envahi par le chaos et la magie noire, 3 héros sont liés malgré eux par un puissant artefact, le Trine. Pontius le brave, Amadeus le magnifique et Zoya la furtive doivent utiliser leurs dons respectifs afin de traverser 13 niveaux bourrés de pièges et d'ennemis.", "Dans un univers moderne et ouvert où tout est connecté à un système de contrôle central appartenant à des sociétés privées, le joueur incarne un groupe de hackeurs et d'assassins capables d'interférer avec les systèmes électroniques."]
         
         for i in 0..<games.count {
            
            let uid = UUID().uuidString
            
            ref.child("games").child(uid).child("name").setValue(games[i])
            ref.child("games").child(uid).child("type").setValue(type[i])
            ref.child("games").child(uid).child("imagePath").setValue("gamesImage/\(uid).jpg")
            ref.child("games").child(uid).child("description").setValue(imagePath[i])
            ref.child("games").child(uid).child("iconPath").setValue("gamesIcon/\(uid).png")
            
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
    
    func getRecentGames(completion: @escaping (_ games: [String : [UIImage]]) -> Void) {
        
        var recentGamesData = [String : [UIImage]]()
        
        
        ref.child("users").child("user1").child("games").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let games = snapshot.value as? [String : AnyObject] {
                let queue = DispatchGroup()
                var count = games.count
                
                for game in games {
                    count -= 1
                    self.getGameInfo(ID: game.key) { info in
                        queue.enter()
                        self.getGameImage(url: info.imageURL) { image in
                            self.getGameImage(url: info.iconURL) { icon in
                                recentGamesData[game.key] = [image, icon]
                                if count == 0 {
                                    queue.leave()
                                    completion(recentGamesData)
                                    print(recentGamesData)
                                }
                            }
                        }
                    }
                }
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
                game.iconURL = data["iconPath"]! as! String
                
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
        button.clipsToBounds = false
        
        let key = Array(recentGames.keys)[atIndex]
        let gameImage = recentGames[key]![1]
        
        button.setImage(gameImage, for: .normal)
    }
    
    @objc func playNowButtonTouched(sender: CircleMenu) {
        
        switchButtonState()
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        
        print("button did selected: \(atIndex)")
        
        selectedGame = atIndex
        
        animateLoading(buttonView, button, animate: true)
        
        let key = Array(recentGames.keys)[atIndex]
        
        gameImage.image = recentGames[key]![0]
        
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
    
    @objc func chatMate() {
        let alertController = UIAlertController(title: "Coming soon !", message:
            "Chatting with a mate is not available yet, stay tuned !", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
        var matePseudo = ""
        
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
                                        
                                        if let param = data["gameParam"] as? [String : AnyObject] {
                                            let parameters = param[game]
                                            
                                            frequency = Int(truncating: parameters!["frequency"]! as! NSNumber)
                                            level = Int(truncating: parameters!["level"]! as! NSNumber)
                                            matePseudo = parameters!["pseudo"] as! String
                                            
                                            if let bioValue = data["bio"] as? String {
                                                bio = bioValue
                                            } else {
                                                bio = ""
                                            }
                                            completion(pseudo, profilePicture, bio, rate, frequency, level, sessionNumber)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func showNewMate(mateID: String, game: String) {
        
        self.mateID = mateID
        
        getUserInfosFrom(id: mateID, game: game) { (name, profilePic, bio, rate, frequency, level, sessionNumber) in
            
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
                
                self.showNewMate(mateID: mateID, game: gameID)
                
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
                
                let newRef = self.ref.child("matchmaking").child(gameID).child("rooms").child(userID)
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
        
        let refH = ref.child("matchmaking").child(gameID).child("rooms").child(userId)
        
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
        
        let newRef = ref.child("matchmaking").child(gameID).child("rooms").child(user.uid)
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
        
        let vc = UserReviewViewController()
        
        vc.mateID = mateID
        show(vc, sender: AnyObject.self)
        
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
            make.top.equalTo(mateFrequencyValueLabel.snp.bottom).offset(10)
        }
        mateSkip.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.right.equalTo(mateCall.snp.left).offset(-20)
            make.bottom.equalTo(mateCall.snp.bottom)
        }
        mateChat.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.left.equalTo(mateCall.snp.right).offset(20)
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
