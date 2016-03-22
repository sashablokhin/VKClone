//
//  FeedViewController.swift
//  VKClone
//
//  Created by Alexander Blokhin on 12.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit
import Alamofire

class FeedViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Alamofire.request(.GET, "https://api.vk.com/method/newsfeed.get", parameters: ["access_token": VKAPI.sharedInstance.accessToken!, "filters":"post"]).responseJSON { response in
            
            if let JSON = response.result.value {
                
                /*
                let photoInfos = (JSON.valueForKey("photos") as! [NSDictionary]).filter({
                    ($0["nsfw"] as! Bool) == false
                }).map {
                    PhotoInfo(id: $0["id"] as! Int, url: $0["image_url"] as! String)
                }
                
                self.photos.addObjectsFromArray(photoInfos)
                
                self.collectionView!.reloadData()*/
                
                if let response = JSON.valueForKey("response") as? NSDictionary {
                    if let items = response.valueForKey("items") as? NSArray {
                        print(items)
                    }
                }
                
                
                
                //print(JSON)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCell
        
        cell.groupImageView.image = UIImage(named: "logo")

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
