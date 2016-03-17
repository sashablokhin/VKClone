//
//  ForgetPswdViewController.swift
//  VKClone
//
//  Created by Alexander Blokhin on 16.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit
import SHSPhoneComponent

class ForgetPswdViewController: UIViewController, CountryCodesDelegate {

    @IBOutlet var tableView: UITableView!
    
    var nextBarButton: UIBarButtonItem!
    
    let phoneCell = MATextFieldCell(type: MATextFieldType.Phone, action: MATextFieldActionType.Done)
    var phoneTextField: SHSPhoneTextField!
    
    var cells = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneCell.textField.becomeFirstResponder()
        
        navigationController?.navigationBarHidden = false
        
        navigationItem.title = "Номер телефона"
        
        nextBarButton = UIBarButtonItem(title: "Далее", style: .Plain, target: self, action: "nextButtonPressed")
        nextBarButton.enabled = false
        
        navigationItem.rightBarButtonItem = nextBarButton
        
        phoneTextField = phoneCell.textField as! SHSPhoneTextField
        
        phoneTextField.textDidChangeBlock = phoneChange
        phoneTextField.formatter.setDefaultOutputPattern("(###) ###-##-##")
        
        //phoneTextField.formatter.addOutputPattern("+# (###) ###-##-##", forRegExp: "^7[0-689]\\d*$")
        //phoneTextField.formatter.addOutputPattern("+### (##) ###-###", forRegExp: "^374\\d*$")
     
        phoneTextField.formatter.prefix = "+7 "
        
        cells = [phoneCell]
    }
    
    func nextButtonPressed() {
        
    }
    
    func countryCodeChanged(countryName: String, code: String) {
        phoneTextField.formatter.prefix = "+\(code) "
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.textLabel?.text = countryName
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        phoneCell.textField.becomeFirstResponder()
    }
    
    func phoneChange(textField: UITextField!) -> Void {
        if phoneTextField.isValid() {
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCountryCodes" {
            let navController = segue.destinationViewController as! UINavigationController
            let vc = navController.viewControllers[0] as! CountryCodesViewController
            vc.countryCodeDelegate = self
        }
    }

}
