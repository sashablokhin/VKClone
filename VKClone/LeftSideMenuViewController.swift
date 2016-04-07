//
//  LeftSideMenuViewController.swift
//  VKClone
//
//  Created by Alexander Blokhin on 05.04.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

struct MenuItem {
    var name: String
    var iconName: String
}

class LeftSideMenuViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController: UISearchController!
    
    var shouldShowSearchResults = false
    
    var menuItems = [
        MenuItem(name: "Новости", iconName: "m_feed"),
        MenuItem(name: "Ответы", iconName: "m_answers"),
        MenuItem(name: "Сообщения", iconName: "m_messages"),
        MenuItem(name: "Друзья", iconName: "m_friends"),
        MenuItem(name: "Группы", iconName: "m_groups"),
        MenuItem(name: "Фотографии", iconName: "m_photos"),
        MenuItem(name: "Видеозаписи", iconName: "m_videos"),
        MenuItem(name: "Игры", iconName: "m_games"),
        MenuItem(name: "Закладки", iconName: "m_favorite"),
        MenuItem(name: "Настройки", iconName: "m_settings")
    ]
    
    var currentMenuIndexPath: NSIndexPath?
    
    var filteredArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.backgroundView = UIView()
        
        configureSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = UIColor(hexString: "#EAEBEC")
        searchController.searchBar.barTintColor = UIColor(hexString: "#364554")
        searchController.searchBar.searchBarStyle = .Prominent
        searchController.searchBar.backgroundImage = UIImage()
        
        if let searchField = searchController.searchBar.valueForKey("_searchField") as? UITextField {
            searchField.backgroundColor = UIColor(hexString: "#4C5865")
        }
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        /*
        filteredArray = menuItems.filter({ (country) -> Bool in
            let countryText: NSString = country
            
            return countryText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location != NSNotFound
        })
        */
        //tableView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            setSelectedByIndexPath(indexPath, selected: false)
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
        
        if currentMenuIndexPath != nil {
            tableView.selectRowAtIndexPath(currentMenuIndexPath, animated: true, scrollPosition: .Top)
            setSelectedByIndexPath(currentMenuIndexPath!, selected: true)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }

    
    func setSelectedByIndexPath(indexPath: NSIndexPath, selected: Bool) {
        if selected {
            let cell  = tableView.cellForRowAtIndexPath(indexPath)
            cell!.contentView.backgroundColor = UIColor(hexString: "#2E3A47")
        } else {
            let cell  = tableView.cellForRowAtIndexPath(indexPath)
            cell!.contentView.backgroundColor = .clearColor()
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return menuItems.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sideMenuCell", forIndexPath: indexPath)
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row]
        }
        else {
            cell.textLabel?.text = menuItems[indexPath.row].name
            cell.imageView?.image = UIImage(named: menuItems[indexPath.row].iconName)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        setSelectedByIndexPath(indexPath, selected: true)
        currentMenuIndexPath = indexPath
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        setSelectedByIndexPath(indexPath, selected: false)
    }
}
