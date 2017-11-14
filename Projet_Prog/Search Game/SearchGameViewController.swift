//
//  SearchGameViewController.swift
//  Projet_Prog
//
//  Created by Paul Bénéteau on 17/10/2017.
//  Copyright © 2017 Paul Bénéteau. All rights reserved.
//

import UIKit

class SearchGameViewController: UIViewController, UITableViewDataSource {
    
    let backgroundGradientView = BGGradientView()
    let VCtitleLabel = UILabel()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var resultSearchController = CustomSearchController()
    var GamesArray = [Games]()
    var filteredGamesArray = [Games]()
    var SearchContainerView = UIView()
    var shadowEffectView = ShadowView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.39, green:0.25, blue:0.65, alpha:1.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchGameTableViewCell.self, forCellReuseIdentifier: "SearchGameCell")
        tableView.backgroundColor = .clear
        
        VCtitleLabel.text = "My Games"
        VCtitleLabel.textColor = .white
        VCtitleLabel.font = UIFont(name: "Roboto-Bold", size: 35)
        
        initSearchBar()
        
        self.view.addSubview(backgroundGradientView)
        self.view.addSubview(SearchContainerView)
        
        self.view.addSubview(VCtitleLabel)
        
        self.SearchContainerView.addSubview(shadowEffectView)
        self.SearchContainerView.addSubview(tableView)
        self.SearchContainerView.addSubview(resultSearchController.searchBar)
                
        tableView.reloadData()
        
        view.setNeedsUpdateConstraints()
    }
    
}

extension SearchGameViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.isActive && !(resultSearchController.searchBar.text?.isEmpty)!) {
            return self.filteredGamesArray.count
        }
        else {
            return self.GamesArray.count
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
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resultSearchController.searchBar.resignFirstResponder()
    }
    
    fileprivate func _configureCell(_ cell: SearchGameTableViewCell, atIndexPath indexPath: IndexPath) {
        cell.queue.cancelAllOperations()
        
        let operation: BlockOperation = BlockOperation()
        operation.addExecutionBlock { [weak operation] () -> Void in
            
            DispatchQueue.main.sync(execute: { [weak operation] () -> Void in
                
                if let operation = operation, operation.isCancelled { return }
                
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                
                if (!self.resultSearchController.isActive || (self.resultSearchController.searchBar.text?.isEmpty)!) {
                    cell.gameImage.image = self.GamesArray[indexPath.row].image
                    cell.gameNameLabel.text = self.GamesArray[indexPath.row].name
                    cell.gameTypeLabel.text = self.GamesArray[indexPath.row].type
                } else if (self.resultSearchController.isActive && !(self.resultSearchController.searchBar.text?.isEmpty)!) {
                    cell.gameImage.image = self.filteredGamesArray[indexPath.row].image
                    cell.gameNameLabel.text = self.filteredGamesArray[indexPath.row].name
                    cell.gameTypeLabel.text = self.filteredGamesArray[indexPath.row].type
                }
            })
        }
        cell.queue.addOperation(operation)
    }
}

extension SearchGameViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2) {
            self.SearchContainerView.frame.origin.y -= self.view.frame.height - self.view.frame.height * 0.9
            self.SearchContainerView.frame.size.height += self.view.frame.height - self.view.frame.height * 0.9
            self.SearchContainerView.layoutIfNeeded()
        }
    }
}

extension SearchGameViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredGamesArray.removeAll(keepingCapacity: false)
        
        let searchText = resultSearchController.searchBar.text!
        
        let filered = GamesArray.filter { $0.name.range(of: searchText, options: [.caseInsensitive]) != nil
            || $0.type.range(of: searchText, options: [.caseInsensitive]) != nil }
        
        filteredGamesArray = filered as [Games]
        
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

extension SearchGameViewController {
    
    @objc func swapContainerView(sender: UIButton!) {
        resultSearchController.searchBar.resignFirstResponder()
        resultSearchController.isActive = false
    }
}

// MARK: Constraints
extension SearchGameViewController {
    
    override func updateViewConstraints() {
        
        backgroundGradientView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(self.view.snp.height)
            make.width.equalTo(self.view.snp.width)
            make.center.equalTo(self.view.snp.center)
        }
        
        VCtitleLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view.snp.width).multipliedBy(0.9)
            make.height.equalTo(37)
            make.left.equalTo(self.view.snp.left).offset(20)
            make.topMargin.equalTo(20)
        }
        SearchContainerView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(self.view.snp.height).multipliedBy(0.88)
            make.width.equalTo(self.view.snp.width)
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        tableView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(self.SearchContainerView.snp.height)
            make.width.equalTo(self.view.snp.width)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(SearchContainerView.snp.top).offset(resultSearchController.searchBar.frame.height + 15)
        }
        shadowEffectView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(self.view.snp.width)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.SearchContainerView.snp.top).offset(3)
        }
        super.updateViewConstraints()
    }
}
