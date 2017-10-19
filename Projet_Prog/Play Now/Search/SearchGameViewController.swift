//
//  SearchGameViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 17/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class SearchGameViewController: UIViewController, UITableViewDataSource {
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    var resultSearchController = CustomSearchController()
    
    var allGames = [Games]()
    
    var filteredGames = [Games]()
    
    var containerView = UIView()
    
    var shadowEffectView = ShadowView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchGameTableViewCell.self, forCellReuseIdentifier: "SearchGameCell")
        tableView.backgroundColor = .clear
        
        initSearchBar()
        
        self.view.addSubview(containerView)
        self.containerView.addSubview(shadowEffectView)
        self.containerView.addSubview(tableView)
        self.containerView.addSubview(resultSearchController.searchBar)
        
        dummyData()
        
        tableView.reloadData()
        
        view.setNeedsUpdateConstraints()
    }
    
    func dummyData() {
        
        var imagesName = [String]()
        
        for _ in 0..<30 {
            imagesName.append("\(arc4random_uniform(33))")
        }
        
        for i in 0..<21 {
            
            allGames.append(Games(name: "LEAGUE OF LEGENDS \(i)", type: "MOBA", image: UIImage(named: "\(imagesName[i])")!))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension SearchGameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.isActive && !(resultSearchController.searchBar.text?.isEmpty)!) {
            return self.filteredGames.count
        }
        else {
            return self.allGames.count
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? SearchGameTableViewCell {
            _configureCell(cell, atIndexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchGameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchGameCell", for: indexPath) as! SearchGameTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultSearchController.searchBar.resignFirstResponder()
    }
    
    fileprivate func _configureCell(_ cell: SearchGameTableViewCell, atIndexPath indexPath: IndexPath)
    {
        cell.queue.cancelAllOperations()
        
        let operation: BlockOperation = BlockOperation()
        operation.addExecutionBlock { [weak operation] () -> Void in
            
            DispatchQueue.main.sync(execute: { [weak operation] () -> Void in
                
                if let operation = operation, operation.isCancelled { return }
                
                cell.backgroundColor = .clear
                
                if (!self.resultSearchController.isActive || (self.resultSearchController.searchBar.text?.isEmpty)!) {
                    cell.gameImage.image = self.allGames[indexPath.row].image
                    cell.gameNameLabel.text = self.allGames[indexPath.row].name
                    cell.gameTypeLabel.text = self.allGames[indexPath.row].type
                } else if (self.resultSearchController.isActive && !(self.resultSearchController.searchBar.text?.isEmpty)!) {
                    cell.gameImage.image = self.filteredGames[indexPath.row].image
                    cell.gameNameLabel.text = self.filteredGames[indexPath.row].name
                    cell.gameTypeLabel.text = self.filteredGames[indexPath.row].type
                }
            })
        }
        
        cell.queue.addOperation(operation)
    }
}

extension SearchGameViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        resultSearchController.searchBar.showsCancelButton = false
    }
}

extension SearchGameViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredGames.removeAll(keepingCapacity: false)
        
        let searchText = resultSearchController.searchBar.text!
        
        let filered = allGames.filter { $0.name.range(of: searchText, options: [.caseInsensitive]) != nil
            || $0.type.range(of: searchText, options: [.caseInsensitive]) != nil }
        
        filteredGames = filered as [Games]
        
        self.tableView.reloadData()
    }
    
}

// MARK: Search Bar
extension SearchGameViewController {
    
    func initSearchBar() {
        
        self.resultSearchController = ({
            let controller = CustomSearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search a game ..."
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false
            controller.obscuresBackgroundDuringPresentation = false
            
            for view in controller.searchBar.subviews.last!.subviews {
                if type(of: view) == NSClassFromString("UISearchBarBackground") {
                    view.alpha = 0
                }
                if type(of: view) == NSClassFromString("UISearchBarTextField") {
                    let searchField: UITextField = view as! UITextField
                    searchField.font = UIFont(name: "Roboto-Light", size: 23)
                }
            }
            controller.searchBar.searchBarStyle = .default
            controller.searchBar.barTintColor = UIColor.clear
            controller.searchBar.backgroundColor = UIColor.clear
            controller.searchBar.isTranslucent = false
            controller.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            controller.searchBar.showsCancelButton = false
            
            
            return controller
        })()
    }
}

// MARK: Constraints
extension SearchGameViewController {
    
    override func updateViewConstraints() {
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(self.view.snp.height).multipliedBy(0.95)
            make.width.equalTo(self.view.snp.width)
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(self.view.snp.height)
            make.width.equalTo(self.view.snp.width)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(containerView.snp.top).offset(resultSearchController.searchBar.frame.height + 15)
        }
        
        shadowEffectView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(self.view.snp.width)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.containerView.snp.top).offset(3)
        }
        
        super.updateViewConstraints()
    }
}
