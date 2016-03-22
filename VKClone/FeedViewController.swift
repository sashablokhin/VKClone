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
    
    var posts = [PostInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Alamofire.request(.GET, "https://api.vk.com/method/newsfeed.get", parameters: ["access_token": VKAPI.sharedInstance.accessToken!]).responseJSON { response in
            
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
                
                    if let items = response.valueForKey("items") as? [NSDictionary] {
                        
                        //print(items)
                        
                        for item in items {
                     
                            let postInfo = PostInfo()
                            
                            
                            let sourceID = item.valueForKey("source_id") as! Int
                            let type = item.valueForKey("type") as! String
                            //let postId = item.valueForKey("post_id") as! Int64
                            let unixtime = item.valueForKey("date") as! NSTimeInterval
                            
                            let date = NSDate(timeIntervalSince1970: unixtime)
                            
                            let currentDate = NSDate()

                            
                            //print(date.compare(currentDate))
                            
                            
                           // print(utcTimeZoneStr)
                            //print(sourceID)
                            //print(item)
                            
                            //print(groupsDict[abs(sourceID)])

                            
                            let groups = response.valueForKey("groups") as! [NSDictionary]
                            
                            for group in groups {
                                
                                let groupID = group.valueForKey("gid") as! Int
                                if groupID == abs(sourceID) {
                                    //print(group.valueForKey("name"))
                                    //print(group)
                                    
                                    postInfo.title = group.valueForKey("name") as? String
                                    postInfo.image = group.valueForKey("photo_medium") as? String
                                }
                                
                                
                            }
                            
                            self.posts.append(postInfo)
                            self.tableView.reloadData()
                        }
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
        return posts.count//20
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCell
        
        //cell.groupImageView.image = UIImage(named: "logo")
        cell.postTitleLabel.text = posts[indexPath.row].title
        //cell.textLabel?.text = posts[indexPath.row].title
        
        
        let imageURL = posts[indexPath.row].image
        
        //print(imageURL)
        
        Alamofire.request(.GET, imageURL!).response { _, _, data, _ in
            let image = UIImage(data: data!)
            cell.groupImageView.image = image
        }


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
