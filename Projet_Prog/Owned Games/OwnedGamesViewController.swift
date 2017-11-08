//
//  PlayNowViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 15/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class OwnedGamesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var containerView = UIView()
    var VCtitleLabel = UILabel()
    
    var noGamesImage = UIImageView()
    var noGamesInfoLabel = UILabel()
    var noGamesHelpLabel = UILabel()
    
    var searchBar = UISearchBar()
    var searchActive = false
    
    var collectionView: UICollectionView!
    
    var GamesArray = [Games]()
    var filteredGamesArray = [Games]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isHeroEnabled = true
        
        view.backgroundColor = .clear
        containerView.backgroundColor = .clear
        
        VCtitleLabel.text = "My Games"
        VCtitleLabel.textColor = .white
        VCtitleLabel.font = UIFont(name: "Roboto-Bold", size: 19)
        VCtitleLabel.textAlignment = .center
        
        noGamesImage.image = UIImage(named: "addGame_ic")
        noGamesImage.isHidden = true
        
        noGamesInfoLabel.text = "You don’t have any game yet"
        noGamesInfoLabel.font = UIFont(name: "Roboto-Medium", size: 20)
        noGamesInfoLabel.textColor = .white
        noGamesInfoLabel.textAlignment = .center
        
        noGamesHelpLabel.text = "Search a game and add it to your collection !"
        noGamesHelpLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        noGamesHelpLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        noGamesHelpLabel.textAlignment = .center
        
        GamesArray = allGames()
        
        initCollectionView()
        initSearchBar()
        
        view.addSubview(VCtitleLabel)
        view.addSubview(containerView)
        containerView.addSubview(noGamesImage)
        containerView.addSubview(noGamesInfoLabel)
        containerView.addSubview(noGamesHelpLabel)
        containerView.addSubview(collectionView)
        
        containerView.addSubview(searchBar)
        
        view.setNeedsUpdateConstraints()
        
    }
    
    func initCollectionView() {
        
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 5)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        
        collectionView.register(OwnedGamesCollectionViewCell.self, forCellWithReuseIdentifier: "OGCell")
        
        if GamesArray.isEmpty && !searchActive {
            noGamesImage.isHidden = false
            noGamesInfoLabel.isHidden = false
            noGamesHelpLabel.isHidden = false
        } else {
            collectionView.reloadData()
            noGamesInfoLabel.isHidden = true
            noGamesHelpLabel.isHidden = true
        }
    }
}

// Table view delegate
extension OwnedGamesViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        if searchActive {
//            return 2
//        } else {
//            return 1
//        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filteredGamesArray.count
        } else {
            return GamesArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: OwnedGamesCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "OGCell", for: indexPath) as? OwnedGamesCollectionViewCell
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? OwnedGamesCollectionViewCell
        {
            _configureCell(cell, atIndexPath: indexPath)
        }
    }
    
    fileprivate func _configureCell(_ cell: OwnedGamesCollectionViewCell, atIndexPath indexPath: IndexPath) {
        cell.queue.cancelAllOperations()
        
        let operation: BlockOperation = BlockOperation()
        operation.addExecutionBlock { [weak operation] () -> Void in
            
            DispatchQueue.main.sync(execute: { [weak operation] () -> Void in
                
                if let operation = operation, operation.isCancelled { return }
                
                cell.backgroundColor = .clear
                cell.contentView.layer.cornerRadius = 10
                cell.contentView.clipsToBounds = true
                
                if self.searchActive {
                    cell.gameImage.image = self.filteredGamesArray[indexPath.row].image
                    cell.gameNameLabel.text = self.filteredGamesArray[indexPath.row].name
                    cell.gameTypeLabel.text = self.filteredGamesArray[indexPath.row].type
                } else {
                    cell.gameImage.image = self.GamesArray[indexPath.row].image
                    cell.gameNameLabel.text = self.GamesArray[indexPath.row].name
                    cell.gameTypeLabel.text = self.GamesArray[indexPath.row].type
                }
            })
        }
        cell.queue.addOperation(operation)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //show(GameViewController(), sender: Any.self)
        
        let vc = GameViewController()
        vc.gameImage.alpha = 0.1
        vc.view.backgroundColor = .white
        
        present(vc, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: Items Sizes
extension OwnedGamesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.95, height: 250)
    }
}

// MARK: Search bar delegate
extension OwnedGamesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        containerView.addGestureRecognizer(tap)
        collectionView.addGestureRecognizer(tap)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if containerView.gestureRecognizers != nil {
            for gesture in containerView.gestureRecognizers! {
                if let recognizer = gesture as? UITapGestureRecognizer {
                    containerView.removeGestureRecognizer(recognizer)
                }
            }
        }
        if collectionView.gestureRecognizers != nil {
            for gesture in collectionView.gestureRecognizers! {
                if let recognizer = gesture as? UITapGestureRecognizer {
                    collectionView.removeGestureRecognizer(recognizer)
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    @objc func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredGamesArray.removeAll(keepingCapacity: false)

        filteredGamesArray = GamesArray.filter { $0.name.range(of: searchText, options: [.caseInsensitive]) != nil
            || $0.type.range(of: searchText, options: [.caseInsensitive]) != nil }
        
        if searchText.isEmpty {
            searchActive = false
        } else {
            searchActive = true
        }
        collectionView.reloadData()
    }
}

// MARK: Search Bar
extension OwnedGamesViewController {
    
    func initSearchBar() {
        
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search a game ..."
        searchBar.searchBarStyle = .default
        searchBar.barTintColor = .clear
        searchBar.backgroundColor = .clear
        searchBar.isTranslucent = false
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.showsCancelButton = false
        searchBar.setImage(UIImage(named: "search_ic"), for: .search, state: .normal)
        
        for view in searchBar.subviews.last!.subviews {
            if type(of: view) == NSClassFromString("UISearchBarBackground") {
                view.alpha = 0
            }
            if type(of: view) == NSClassFromString("UISearchBarTextField") {
                let searchField: UITextField = view as! UITextField
                searchField.font = UIFont(name: "Roboto-Light", size: 23)
                searchField.backgroundColor = .clear
                searchField.textColor = .white
                searchField.attributedPlaceholder = NSAttributedString(string: "Search a game ...",
                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)])
                searchField.clearButtonMode = .never
            }
        }
    }
}


// MARK: Constraints
extension OwnedGamesViewController {
    
    override func updateViewConstraints() {
        
        VCtitleLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.6)
            make.height.equalTo(20)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(30)
        }
        containerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height).multipliedBy(0.88)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom)
        }
        noGamesImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(120)
            make.height.equalTo(96)
            make.centerX.equalTo(containerView.snp.centerX)
            make.centerY.equalTo(containerView.snp.centerY).offset(-70)
        }
        noGamesInfoLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.9)
            make.height.equalTo(22)
            make.centerX.equalTo(containerView.snp.centerX)
            make.top.equalTo(noGamesImage.snp.bottom).offset(40)
        }
        noGamesHelpLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.9)
            make.height.equalTo(22)
            make.centerX.equalTo(containerView.snp.centerX)
            make.top.equalTo(noGamesInfoLabel.snp.bottom).offset(10)
        }
        collectionView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width)
            make.height.equalTo(containerView.snp.height).offset(-50)
            make.centerX.equalTo(containerView.snp.centerX)
            make.bottom.equalTo(containerView.snp.bottom)
        }
        
        super.updateViewConstraints()
    }
}

extension MenuViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
