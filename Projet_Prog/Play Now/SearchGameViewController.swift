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
    
    var Games = ["Fifa 18", "League of Legends", "Tera", "Overwatch", "Minecraft"]
    
    var filteredGames = [String]()
    
    var containerView = UIView()
    
    var shadowEffectView = ShadowView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchGameCell")
        tableView.backgroundColor = .clear
        
        self.view.addSubview(containerView)
        
        self.containerView.addSubview(shadowEffectView)
        
        self.containerView.addSubview(resultSearchController.searchBar)
        
        self.containerView.addSubview(tableView)

        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
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

extension SearchGameViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.resultSearchController.isActive && !(resultSearchController.searchBar.text?.isEmpty)!) {
            return self.filteredGames.count
        }
        else {
            return self.Games.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchGameCell")!
        
        if (self.resultSearchController.isActive && !(resultSearchController.searchBar.text?.isEmpty)!) {
            cell.textLabel?.text = filteredGames[indexPath.row]
            
            return cell
        }
        else {
            cell.textLabel?.text = Games[indexPath.row]
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (Games as NSArray).filtered(using: searchPredicate)
        filteredGames = array as! [String]
        
        self.tableView.reloadData()
    }
    
}
