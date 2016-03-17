//
//  MATextFieldCell.swift
//
//  Created by Mike Amaral on 6/12/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

import UIKit
import SHSPhoneComponent
//import CoreTelephony

enum MATextFieldType: Int {
    case Default = 0, Name, Phone, Email, Address, StateAbbr, ZIP, Number, Decimal, Password, URL, NonEditable
}

enum MATextFieldActionType: Int {
    case None = 0, Next, Done
}

class MATextFieldCell: UITableViewCell, UITextFieldDelegate {
    var textField: UITextField!// = SHSPhoneTextField(frame: CGRectZero)
    
    let fieldVeriticalPadding: CGFloat = 7.0
    let fieldHorizontalPadding: CGFloat = 10.0
    let toolbarHeight: CGFloat = 50.0
    var actionBlock: (() -> ())?
    let type: MATextFieldType
    let action: MATextFieldActionType
    var shouldAttemptFormat: Bool = true

    
    required init?(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(type: MATextFieldType?, action: MATextFieldActionType?) {
        // if the optional type and action enums were provided, set them
        self.type = type != nil ? type! : .Default
        self.action = action != nil ? action! : .None
        
        super.init(style: .Default, reuseIdentifier: nil)
        
        // basic configuration and creation of text field to fit within the bounds of the
        // cell and handle rotation nicely
        self.selectionStyle = .None
        
        // configure the textfield based on the type and action
        configureTextField()
    }
    
    // MARK: - setup
    
    func configureTextField() {
        var requiresToolbar = false
        
        // based on the type of the field, we want to format the textfield according
        // to the most user-friendly conventions. Any of these values can be overridden
        // later if users want to customize further. Any of the fields with numeric keyboard
        // types require a toolbar to handle the next/done functionality
        switch (self.type) {
        case .Default:
            self.textField = UITextField(frame: CGRectZero)
            self.textField.autocapitalizationType = .Sentences
            self.textField.autocorrectionType = .Yes
            self.textField.keyboardType = .Default
        case .Name:
            self.textField = UITextField(frame: CGRectZero)
            self.textField.autocapitalizationType = .Words
            self.textField.autocorrectionType = .No
            self.textField.keyboardType = .Default
        case .Phone:
            self.textField = SHSPhoneTextField(frame: CGRectZero)
            self.textField.autocapitalizationType = .None
            self.textField.autocorrectionType = .No
            self.textField.keyboardType = .NumberPad
            
            /*
            // Setup the Network Info and create a CTCarrier object
            let networkInfo = CTTelephonyNetworkInfo()
            let carrier = networkInfo.subscriberCellularProvider
            
            // Get carrier name
            let countryCode = carrier?.isoCountryCode
            */
            
        case .Email:
            self.textField = UITextField(frame: CGRectZero)
            self.textField.autocapitalizationType = .None
            self.textField.autocorrectionType = .No
            self.textField.keyboardType = .EmailAddress
            self.textField.clearButtonMode = .WhileEditing
            
            
        case .Address:
            self.textField = UITextField(frame: CGRectZero)
            self.textField.autocapitalizationType = .Words
            self.textField.autocorrectionType = .Yes
            self.textField.keyboardType = .Default
        case .StateAbbr:
            self.textField = UITextField(frame: CGRectZero)
            self.textField.autocapitalizationType = .AllCharacters
            self.textField.autocorrectionType = .No
            self.textField.keyboardType = .Default
        case .ZIP:
            self.textField = UITextField(frame: CGRectZero)
            self.textField.autocapitalizationType = .None
            self.textField.autocorrectionType = .No
            self.textField.keyboardType = .NumberPad
            requiresToolbar = true
        case .Number:
            self.textField = UITextField(frame: CGRectZero)
            self.textField.autocapitalizationType = .None
            self.textField.autocorrectionType = .No
            self.textField.keyboardType = .NumberPad
            requiresToolbar = true
        case .Decimal:
            self.textField = UITextField(frame: CGRectZero)
            self.textField.autocapitalizationType = .None
            self.textField.autocorrectionType = .No
            self.textField.keyboardType = .DecimalPad
            requiresToolbar = true
        case .Password:
            self.textField = UITextField(frame: CGRectZero)
            self.textField.autocapitalizationType = .None
            self.textField.autocorrectionType = .No
            self.textField.keyboardType = .Default
            self.textField.secureTextEntry = true
        case .URL:
            self.textField = UITextField(frame: CGRectZero)
            self.textField.autocapitalizationType = .None
            self.textField.autocorrectionType = .No
            self.textField.keyboardType = UIKeyboardType.URL
        case .NonEditable:
            self.textField = UITextField(frame: CGRectZero)
            self.textField.enabled = false
        }
        
        // if any of the fields require a toolbar, set up the toolbar with the appropriate title,
        // otherwise set the appropriate return key type on the keyboard
        switch (self.action) {
        case .None:
            self.textField.returnKeyType = .Default
        case .Next:
            if requiresToolbar {
                setupToolbarWithButtonTitle("Далее")
            }
            else {
                self.textField.returnKeyType = .Next
            }
        case .Done:
            if requiresToolbar {
                setupToolbarWithButtonTitle("Готово")
            }
            else {
                self.textField.returnKeyType = .Done
            }
        }
        
        
        
        
        self.textField.delegate = self
        self.textField.frame = CGRectMake(fieldHorizontalPadding, fieldVeriticalPadding, CGRectGetWidth(self.contentView.frame) - 2 * fieldHorizontalPadding, CGRectGetHeight(self.contentView.frame) - (2 * fieldVeriticalPadding))
        
        self.textField.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.textField.tintColor = UIColor.blueColor()
        self.contentView.addSubview(self.textField)
        
        
    }
    
    func setupToolbarWithButtonTitle(buttonTitle: String) {
        // create the toolbar and use a flexible space button to right-mount the action button, and point it towards the function
        // that will call the action block
        let toolBar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), toolbarHeight))
        let flexibleSpaceButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let actionButton: UIBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .Plain, target: self, action: "handleToolbarButtonPressed")
        toolBar.items = [flexibleSpaceButton, actionButton]
        self.textField.inputAccessoryView = toolBar
    }
    
    func handleToolbarButtonPressed() {
        self.actionBlock?()
    }
    
    
    // MARK: - text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.actionBlock?()
        return false
    }
    
    /*
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        switch (self.type) {
            // the state abbreviation cell should only allow two characeters
        case .StateAbbr:
            let resultString: NSString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString:string)
            return resultString.length < 3
            
            // the zip cell should only allow 5 characters - TODO: allow for hyphenated zips
        case .ZIP:
            let resultString: NSString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString:string)
            return resultString.length < 6
            
            // the phone cell should only allow up to 15 characters, and we want to flag that we should
            // attempt to format the phone number as long as they are adding characters... if they are
            // deleting characters ignore it and don't attempt to format - TODO: allow for prepended '1' and extentions
        case .Phone:
            let resultString: NSString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString:string)
            let oldString: NSString = self.textField.text!
            let oldCount = oldString.length
            let newCount = resultString.length
            shouldAttemptFormat = newCount > oldCount
            return true//newCount < 15
            
            // otherwise we should just let them continue
        default:
            return true
        }
    }*/
    
    
    // MARK: - phone number formatting
    /*
    func formatPhoneNumber() {
        // this value is determined when textField shouldChangeCharactersInRange is called on a phone
        // number cell - if a user is deleting characters we don't want to try to format it, otherwise
        // using the current logic below certain deletions will have no effect
        if !shouldAttemptFormat {
            return
        }
        
        // here we are leveraging some of the objective-c NSString functions to help parse and modify
        // the phone number... first we strip anything that's not a number from the textfield, and then
        // depending on the current value we append formatting characters to make it pretty
        let currentValue: NSString = self.textField.text!
        let strippedValue: NSString = currentValue.stringByReplacingOccurrencesOfString("[^0-9]", withString: "", options: .RegularExpressionSearch, range: NSMakeRange(0, currentValue.length))
        var formattedString: NSString = ""
        if strippedValue.length == 0 {
            formattedString = "";
        }
        else if strippedValue.length < 3 {
            formattedString = "(" + (strippedValue as String)
        }
        else if strippedValue.length == 3 {
            formattedString = "(" + (strippedValue as String) + ") "
        }
        else if strippedValue.length < 6 {
            formattedString = "(" + strippedValue.substringToIndex(3) + ") " + strippedValue.substringFromIndex(3)
        }
        else if strippedValue.length == 6 {
            formattedString = "(" + strippedValue.substringToIndex(3) + ") " + strippedValue.substringFromIndex(3) + "-"
        }
        else if strippedValue.length <= 10 {
            formattedString = "(" + strippedValue.substringToIndex(3) + ") " + strippedValue.substringWithRange(NSMakeRange(3, 3)) + "-" + strippedValue.substringFromIndex(6)
        }
        else if strippedValue.length >= 11 {
            formattedString = "(" + strippedValue.substringToIndex(3) + ") " + strippedValue.substringWithRange(NSMakeRange(3, 3)) + "-" + strippedValue.substringWithRange(NSMakeRange(6, 4)) + " x" + strippedValue.substringFromIndex(10)
        }
        
        self.textField.text = formattedString as String
    }*/
    
}


extension SHSPhoneTextField {
    func isValid() -> Bool {
        return (self.phoneNumber() as NSString).length == 11
    }
}


