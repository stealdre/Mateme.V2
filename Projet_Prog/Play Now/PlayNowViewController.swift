//
//  PlayNowViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 15/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class PlayNowViewController: UIViewController, UICollectionViewDataSource {
    
    var didSetupConstraints = false
    
    var titleVCLabel = UILabel()
    
    var collectionView = OwnedGamesCollectionView()
    
    var ownedGames = [Games]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleVCLabel.text = "Play Now"
        titleVCLabel.textColor = .black
        titleVCLabel.font = UIFont(name: "Roboto-Bold", size: 35)
        self.view.addSubview(titleVCLabel)
        
        dummyData()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.view.addSubview(collectionView)
        
        self.collectionView.reloadData()
        
        view.setNeedsUpdateConstraints()
    }
    
    func dummyData() {
        
        var imagesName = [String]()
        
        for _ in 0..<30 {
            imagesName.append("\(arc4random_uniform(33))")
        }
        
        for i in 0..<20 {
            
            ownedGames.append(Games(name: "LEAGUE OF LEGENDS \(i)", type: "MOBA", image: UIImage(named: "\(imagesName[i])")!))
        }
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            titleVCLabel.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(self.view.snp.width).multipliedBy(0.8)
                make.height.equalTo(35)
                make.left.equalTo(self.view.snp.left).offset(15)
                make.top.equalTo(self.view.snp.top).offset(30)
            }
            
            collectionView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(self.view.snp.width)
                make.height.equalTo(self.view.snp.height).multipliedBy(0.9)
                make.centerX.equalTo(self.view.snp.centerX)
                make.bottom.equalTo(self.view.snp.bottom)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}

extension PlayNowViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ownedGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: OwnedGameUICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "OGCell", for: indexPath) as? OwnedGameUICollectionViewCell
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? OwnedGameUICollectionViewCell
        {
            _configureCell(cell, atIndexPath: indexPath)
        }
    }
    
    fileprivate func _configureCell(_ cell: OwnedGameUICollectionViewCell, atIndexPath indexPath: IndexPath)
    {
        cell.queue.cancelAllOperations()
        
        let operation: BlockOperation = BlockOperation()
        operation.addExecutionBlock { [weak operation] () -> Void in
            
            DispatchQueue.main.sync(execute: { [weak operation] () -> Void in
                
                if let operation = operation, operation.isCancelled { return }
                
                cell.gameImage.image = self.ownedGames[indexPath.row].image
                cell.backgroundColor = .clear
            })
        }
        
        cell.queue.addOperation(operation)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let defaultOwnedGamesCellSize = CGSize(width: 165, height: 165)
        let firstOwnedGamesCellSize = CGSize(width: self.view.frame.width - 30, height: 165)
        
        if (indexPath.row == 0) {
            return firstOwnedGamesCellSize
        }
        return defaultOwnedGamesCellSize
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 70)
        
    }
}
