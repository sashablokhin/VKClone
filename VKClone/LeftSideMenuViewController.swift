//
//  LeftSideMenuViewController.swift
//  VKClone
//
//  Created by Alexander Blokhin on 05.04.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit


class MenuItem {
    var name: String
    var iconName: String
    var buttonName: String?
    
    init(name: String, iconName: String, buttonName: String? = nil) {
        self.name = name
        self.iconName = iconName
        self.buttonName = buttonName
    }
}


enum SizeMode {
    case Compact
    case Full
}

class CustomSearchBar: UISearchBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setShowsCancelButton(true, animated: false)
        setSizeMode(.Compact)
    }
    
    override func drawRect(rect: CGRect) {
        setSizeMode(.Compact)
        
        if let cancelButton = self.valueForKey("_cancelButton") as? UIButton {
            cancelButton.setTitle("Отменить", forState: .Normal)
        }
        
        super.drawRect(rect)
    }
    
    
    func setSizeMode(mode: SizeMode) {
        if mode == .Compact {
            if let cancelButton = self.valueForKey("_cancelButton") as? UIButton {
                cancelButton.alpha = 0
                cancelButton.frame.origin.x += 20
                
                if let searchField = self.valueForKey("_searchField") as? UITextField {
                    searchField.frame.size.width = 260
                }
            }
        } else if mode == .Full {
            if let cancelButton = self.valueForKey("_cancelButton") as? UIButton {
                cancelButton.alpha = 1
                cancelButton.frame.origin.x -= 40
                
                if let searchField = self.valueForKey("_searchField") as? UITextField {
                    searchField.frame.size.width = cancelButton.frame.origin.x - 20
                }
            }
        }
    }
}


class CustomSearchController: UISearchController, UISearchBarDelegate  {
    
    lazy var _searchBar: CustomSearchBar = {
        [unowned self] in
        let result = CustomSearchBar()
        result.delegate = self
        
        return result
        }()
    
    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }
}


class LeftSideMenuViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    var searchController: CustomSearchController!
    
    var shouldShowSearchResults = false
    
    var menuItems = [MenuItem]() 
    
    var currentMenuIndexPath: NSIndexPath?
    
    var filteredArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        tableView.tableFooterView = UIView(frame:CGRectZero)
        tableView.backgroundView = UIView()
        
        configureMenuItems()
        configureSearchController()
    }
    
    deinit{
        if let superView = searchController.view.superview
        {
            superView.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func configureMenuItems() {
        menuItems = [
            MenuItem(name: "Александр", iconName: "navlogo", buttonName: "m_photo"),
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
    }
    
    func configureSearchController() {
        searchController = CustomSearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.delegate = self
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
    
    
    // MARK: - UISearchControllerDelegate
    
    var searchBarBeginEditing: (() -> ())?
    var searchBarEndEditing: (() -> ())?
    
    func didPresentSearchController(searchController: UISearchController) {
        if let handler = searchBarBeginEditing {
            handler()
        }
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        if let handler = searchBarEndEditing {
            handler()
        }
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        /*let searchString = searchController.searchBar.text
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("sideMenuCell", forIndexPath: indexPath) as! MenuCell
        
        if shouldShowSearchResults {
            //cell.textLabel?.text = filteredArray[indexPath.row]
        }
        else {
            cell.textLabel?.text = menuItems[indexPath.row].name
            cell.textLabel?.textColor = UIColor(hexString: "#EAEBEC")

            if indexPath.row == 0 {
                cell.imageView?.image = UIImage(named: menuItems[indexPath.row].iconName)?.resizeImage(toSize: CGSizeMake(25, 25))
                cell.imageView?.clipsToBounds = true
                cell.imageView?.layer.cornerRadius = 10
                
                cell.menuButton.setImage(UIImage(named: menuItems[indexPath.row].buttonName!), forState: .Normal)
                cell.buttonConstraint.constant = 225
                
            } else {
                cell.imageView?.image = UIImage(named: menuItems[indexPath.row].iconName)
            }
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
