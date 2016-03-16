//
//  ForgetPswdViewController.swift
//  VKClone
//
//  Created by Alexander Blokhin on 16.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit
import SHSPhoneComponent

class ForgetPswdViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var nextBarButton: UIBarButtonItem!
    
    let phoneCell = MATextFieldCell(type: MATextFieldType.Phone, action: MATextFieldActionType.Done)
    
    var cells = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneCell.textField.becomeFirstResponder()
        
        navigationController?.navigationBarHidden = false
        
        navigationItem.title = "Номер телефона"
        
        nextBarButton = UIBarButtonItem(title: "Далее", style: .Plain, target: self, action: "nextButtonPressed")
        nextBarButton.enabled = false
        
        navigationItem.rightBarButtonItem = nextBarButton
        
        (phoneCell.textField as! SHSPhoneTextField).textDidChangeBlock = phoneChange
        cells = [phoneCell]
    }
    
    func nextButtonPressed() {
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func phoneChange(textField: UITextField!) -> Void {
        if ((phoneCell.textField as! SHSPhoneTextField).phoneNumber() as NSString).length == 11 {
            nextBarButton.enabled = true
        } else {
            nextBarButton.enabled = false
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count + 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("countryCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Россия"
            return cell
        }
        
        return cells[indexPath.row - 1] as! MATextFieldCell
    }

}
