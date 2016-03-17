//
//  CountryCodesViewController.swift
//  VKClone
//
//  Created by Alexander Blokhin on 16.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

@objc protocol CountryCodesDelegate {
    optional func countryCodeChanged(countryName: String, code: String)
}

class Country: NSObject {
    var name: String
    var code: String
    
    init(countryName: String, callingCode: String) {
        self.name = countryName
        self.code = callingCode
    }
}

class Section {
    var countries: [Country] = []
    
    func addCountry(country: Country) {
        self.countries.append(country)
    }
}

class CountryCodesViewController: UITableViewController {
    
    var countryCodeDelegate: CountryCodesDelegate?
    
    var sections = [String : Section?]()
    var sortedSectionNames = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Страна"
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor()]
        
        let cancelBarButton = UIBarButtonItem(title: "Отменить", style: .Plain, target: self, action: "cancelButtonPressed")
        cancelBarButton.tintColor = UIColor.blueColor().colorWithAlphaComponent(0.6)
        
        navigationItem.rightBarButtonItem = cancelBarButton
    
        loadCountries()
    }
    
    
    
    func loadCountries() {
        if let path = NSBundle.mainBundle().pathForResource(NSLocalizedString("countries", comment: ""), ofType: "json") {
            let data = NSData(contentsOfFile: path)
            
            if let data = data {
                do {
                    let countriesDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [NSDictionary]
                    
                    parseCountries(countriesDictionary)
                    
                    tableView.reloadData()
                } catch {
                    print("Json Error: \(error)")
                }
            }
        }

    }
    
    
    func parseCountries(countriesDict: [NSDictionary]) {
        for countryDict in countriesDict {
            let countryTranslations = countryDict.valueForKey("translations") as! NSDictionary
            
            let countryNameDict = countryTranslations.valueForKey("rus") as! NSDictionary
            let countryName = countryNameDict.valueForKey("common") as! String
            
            let callingCodeArray = countryDict.valueForKey("callingCode") as! [String]
            let callingCode = callingCodeArray[0]
            
            let country = Country(countryName: countryName, callingCode: callingCode)

            let sectionName = String(countryName.characters.first!)
            
            if sections[sectionName] == nil {
                let section = Section()
                section.addCountry(country)
                sections[sectionName] = section
            } else {
                let section = sections[sectionName]!
                section!.addCountry(country)
            }
        }
        
        sortedSectionNames = Array(sections.keys).sort()
    }
    
    
    func cancelButtonPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionName = sortedSectionNames[section]
        return sections[sectionName]!!.countries.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("countryCell", forIndexPath: indexPath)
        
        let sectionName = sortedSectionNames[indexPath.section]
        let country = sections[sectionName]!!.countries[indexPath.row]
        
        
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = "+" + country.code

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sectionName = sortedSectionNames[indexPath.section]
        let country = sections[sectionName]!!.countries[indexPath.row]
        
        countryCodeDelegate?.countryCodeChanged!(country.name, code: country.code)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Section headers
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        return sortedSectionNames[section]
    }
    
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return sortedSectionNames
    }
    
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }

}
