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
    var postIds = [NSNumber]()
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        Alamofire.request(.GET, "https://api.vk.com/method/newsfeed.get", parameters: ["access_token": VKAPI.sharedInstance.accessToken!]).responseJSON { response in
            
            if let JSON = response.result.value {
                
                if let response = JSON.valueForKey("response") as? NSDictionary {
                
                    if let items = response.valueForKey("items") as? [NSDictionary] {
                        
                        for item in items {
                            if let postId = item.valueForKey("post_id") {
                                if !self.postIds.contains(postId as! NSNumber) {
                                    
                                    let postInfo = PostInfo()
                                    
                                    let sourceID = item.valueForKey("source_id") as! Int
                                    //let type = item.valueForKey("type")// as! String
                                    if let text = item.valueForKey("text") as? String {
                                        postInfo.text = text
                                    }
                                    
                                    //print(item)
                                    
                                    if let attachments = item.valueForKey("attachments") as? [NSDictionary] {
                                        //print(attachments)
                                        
                                        for attachment in attachments {
                                            print(attachment.allKeys)
                                        }
                                    }
                                    
                                    
                                    self.postIds.append(postId as! NSNumber)
                                    
                                    //print(postId)
                                    
                                    let unixtime = item.valueForKey("date") as! NSTimeInterval
                                    
                                    let date = NSDate(timeIntervalSince1970: unixtime)
                                    
                                    let currentDate = NSDate()
                                    
                                    
                                    let groups = response.valueForKey("groups") as! [NSDictionary]
                                    
                                    var find = false
                                    
                                    for group in groups {
                                        let groupID = group.valueForKey("gid") as! Int
                                        if groupID == abs(sourceID) {
                                            find = true
                                            postInfo.title = group.valueForKey("name") as? String
                                            postInfo.image = group.valueForKey("photo_medium") as? String
                                        }
                                    }
                                    
                                    if find {
                                        self.posts.append(postInfo)
                                        self.tableView.reloadData()
                                    }
                                }
                            }
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
        //cell.postTextLabel.text = posts[indexPath.row].text
        
        cell.postImageView.hidden = true
        
        if let postText = posts[indexPath.row].text {
            let attrStr = try! NSAttributedString(
                data: postText.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            cell.postTextLabel.attributedText = attrStr
            cell.postTextLabel.font = UIFont.systemFontOfSize(16)
        } else {
            cell.postTextLabel.text = ""
        }
        
        
        //cell.textLabel?.text = posts[indexPath.row].title
        
        
        if let imageURL = posts[indexPath.row].image {
        
            Alamofire.request(.GET, imageURL).response { _, _, data, _ in
                let image = UIImage(data: data!)
                cell.groupImageView.image = image
            }
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
