//
//  LoginViewController.swift
//  VKClone
//
//  Created by Alexander Blokhin on 15.03.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let loginCell = MATextFieldCell(type: MATextFieldType.Default, action: MATextFieldActionType.Next)
    let passwordCell = MATextFieldCell(type: MATextFieldType.Password, action: MATextFieldActionType.Done)
    var cells = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginCell.textField.becomeFirstResponder()

        navigationController?.navigationBarHidden = false
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "navlogo")
        
        navigationItem.titleView = imageView
        
        let loginBarButton = UIBarButtonItem(title: "Войти", style: .Plain, target: self, action: "loginButtonPressed")
        loginBarButton.enabled = false
        
        navigationItem.rightBarButtonItem = loginBarButton
        
        generateCells()
        
        self.tableView.contentInset = UIEdgeInsetsMake(view.frame.height / 2 - loginCell.frame.height * 5, 0, 0, 0)
    }
    
    
    func loginButtonPressed() {
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.navigationBarHidden = true
    }
    
    func generateCells() {
        loginCell.textField.placeholder = "Почта или телефон"
        loginCell.actionBlock = {
            self.passwordCell.textField.becomeFirstResponder()
            return
        }
        
        passwordCell.textField.placeholder = "Пароль"
        passwordCell.actionBlock = {
            self.passwordCell.textField.resignFirstResponder()
            return
        }
        
        cells = [loginCell, passwordCell];
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cells[indexPath.row] as! MATextFieldCell
    }

}







