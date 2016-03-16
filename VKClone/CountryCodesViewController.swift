//
//  CountryCodesViewController.swift
//  VKClone
//
//  Created by Alexander Blokhin on 16.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

class Country {
    var name: String
    var code: String
    
    init(countryName: String, callingCode: String) {
        self.name = countryName
        self.code = callingCode
    }
}

class CountryCodesViewController: UITableViewController {
    
    var countriesArray = [Country]()

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
                    
                    countriesArray.sortInPlace { $0.name < $1.name }
                    
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
            
            countriesArray.append(Country(countryName: countryName, callingCode: callingCode))
        }
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return countriesArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("countryCell", forIndexPath: indexPath)

        cell.textLabel?.text = countriesArray[indexPath.row].name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
