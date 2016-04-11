//
//  FeedViewController.swift
//  VKClone
//
//  Created by Alexander Blokhin on 12.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import Alamofire

class FeedViewController: HiddenToolBarTableViewController {
    
    let transitionManager = MenuTransitionManager()
    
    var posts = [PostInfo]()
    var postIds = [NSNumber]()
    
    let dropDownMenuItems = ["Новости", "Рекомендации", "Поиск", "Друзья", "Сообщества"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureTableView()
        loadFeed()
        
        transitionManager.sourceViewController = self
    }
    
    
    func configureNavigationBar() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        menuButton.setImage(UIImage(named: "menu.png"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: "menuButtonPressed", forControlEvents: .TouchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
    }
    
    func menuButtonPressed() {
        performSegueWithIdentifier("showLeftSideMenu", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // set transition delegate for our menu view controller
        if segue.identifier == "showLeftSideMenu" {
            let menu = segue.destinationViewController as! LeftSideMenuViewController
            menu.transitioningDelegate = self.transitionManager
            
            self.transitionManager.menuViewController = menu
        }
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: dropDownMenuItems.first!, items: dropDownMenuItems)
        menuView.checkMarkImage = nil
        menuView.cellHeight = 40
        menuView.cellTextLabelFont = UIFont.systemFontOfSize(16)
        menuView.cellBackgroundColor = UIColor.whiteColor()
        menuView.cellTextLabelColor = UIColor.darkGrayColor()
        menuView.cellSeparatorColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.4)
        menuView.cellSelectionColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.4)
        menuView.cellTextLabelAlignment = .Center
        menuView.animationDuration = 0.4
        
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath) name: \(self.dropDownMenuItems[indexPath])")
        }
    }
    
    func loadFeed() {
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
                                            //print(attachment.allKeys)
                                            
                                            if let photo = attachment.valueForKey("photo") {
                                                //print(photo)
                                                
                                                let postImage = PostImage()
                                                postImage.imageUrl = photo.valueForKey("src_big") as? String
                                                postImage.width = photo.valueForKey("width") as? Int
                                                postImage.height = photo.valueForKey("height") as? Int
                                                
                                                //print(postImage.width)
                                                
                                                postInfo.attachmentImage = postImage
                                            }
                                        }
                                    }
                                    
                                    self.postIds.append(postId as! NSNumber)
                                    
                                    let unixtime = item.valueForKey("date") as! NSTimeInterval
                                    let date = NSDate(timeIntervalSince1970: unixtime)
                                    
                                    postInfo.time = NSDate().offsetFrom(date)
                                    
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostCell
        
        cell.postTitleLabel.text = posts[indexPath.row].title
        cell.timeLabel.text = posts[indexPath.row].time
        
        cell.groupImageRequest?.cancel()
        cell.postImageRequest?.cancel()
        
        if let postText = posts[indexPath.row].text {
            cell.postTextView.text = postText
        } else {
            cell.postTextView.text = ""
        }
        
        if let attachmentImage = posts[indexPath.row].attachmentImage {
            
            cell.postImageView.hidden = false
            
            let imageWidth = CGFloat(attachmentImage.width!)
            let imageHeight = CGFloat(attachmentImage.height!)
            
            let screenWidth = UIScreen.mainScreen().bounds.width - 16
            let ratio = imageHeight / imageWidth
            
            // Calculated Height for the picture
            let newHeight = screenWidth * ratio
            
            cell.widthConstraint.constant = screenWidth
            cell.heightConstraint.constant = newHeight
            
            if let imageUrl = attachmentImage.imageUrl {
                cell.groupImageRequest = Alamofire.request(.GET, imageUrl).response { _, _, data, _ in
                    let image = UIImage(data: data!)
                    cell.postImageView.image = image
                }
            }
        } else {
            cell.postImageView.hidden = true
        }
        
        if let imageURL = posts[indexPath.row].image {
            
            cell.postImageRequest = Alamofire.request(.GET, imageURL).response { _, _, data, _ in
                let image = UIImage(data: data!)
                cell.groupImageView.image = image
            }
        }
        
        cell.postTextView.readMoreHandler = { () -> () in
            tableView.beginUpdates()
            tableView.endUpdates()
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
