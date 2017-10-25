//
//  PlayNowViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 15/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class OwnedGamesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let background = UIImageView()

    var VCtitleLabel = UILabel()
    
    var resultSearchController = CustomSearchController()
    
    var collectionView: UICollectionView!
    
    var GamesArray = [Games]()
    var filteredGamesArray = [Games]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        background.image = UIImage(named: "Background")
        
        VCtitleLabel.text = "My Games"
        VCtitleLabel.textColor = .white
        VCtitleLabel.font = UIFont(name: "Roboto-Bold", size: 35)
        
        GamesArray = allGames()
        
        commonInit()
        
        self.view.addSubview(background)
        self.view.addSubview(VCtitleLabel)
        self.view.addSubview(collectionView)
        
        view.setNeedsUpdateConstraints()
    }
    
    func commonInit() {
        
        initSearchBar()
        
        let layout = OwnedGamesCollectionViewLayout()
        
        layout.itemSize = CGSize(width: 90, height: 120)
        layout.sectionInset = UIEdgeInsets(top: 11, left: 10, bottom: 10, right: 11)
        layout.delegate = self
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        
        collectionView.register(OwnedGamesCollectionViewCell.self, forCellWithReuseIdentifier: "OGCell")
        
        self.collectionView.reloadData()
    }
}

extension OwnedGamesViewController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GamesArray.count
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
                
                cell.gameImage.image = self.GamesArray[indexPath.row].image
                cell.backgroundColor = .clear
            })
        }
        cell.queue.addOperation(operation)
    }
}

// MARK: Items Sizes
extension OwnedGamesViewController: OwnedGamesLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return CGFloat(GamesArray[indexPath.row].image.size.height / 3.7 + CGFloat(arc4random_uniform(50)))
    }
}

extension OwnedGamesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
}

extension OwnedGamesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredGamesArray.removeAll(keepingCapacity: false)
        
        let searchText = resultSearchController.searchBar.text!
        
        let filered = GamesArray.filter { $0.name.range(of: searchText, options: [.caseInsensitive]) != nil
            || $0.type.range(of: searchText, options: [.caseInsensitive]) != nil }
        
        filteredGamesArray = filered as [Games]
        
        self.collectionView.reloadData()
    }
}

// MARK: Search Bar
extension OwnedGamesViewController {
    
    func initSearchBar() {
        self.resultSearchController = ({
            let controller = CustomSearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search a game ..."
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .default
            controller.searchBar.barTintColor = UIColor.clear
            controller.searchBar.backgroundColor = UIColor.clear
            controller.searchBar.isTranslucent = false
            controller.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            controller.searchBar.showsCancelButton = false
            controller.searchBar.delegate = self
            
            for view in controller.searchBar.subviews.last!.subviews {
                if type(of: view) == NSClassFromString("UISearchBarBackground") {
                    view.alpha = 0
                }
                if type(of: view) == NSClassFromString("UISearchBarTextField") {
                    let searchField: UITextField = view as! UITextField
                    searchField.font = UIFont(name: "Roboto-Light", size: 23)
                }
            }
            return controller
        })()
    }
}


// MARK: Constraints
extension OwnedGamesViewController {
    
    override func updateViewConstraints() {
        
        background.snp.makeConstraints {(make) -> Void in
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height)
            make.center.equalTo(self.view.snp.center)
        }
        VCtitleLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view.snp.width).multipliedBy(0.9)
            make.height.equalTo(38)
            make.left.equalTo(self.view.snp.left).offset(20)
            make.topMargin.equalTo(20)
        }
        collectionView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view.snp.width)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.88)
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        super.updateViewConstraints()
    }
}
