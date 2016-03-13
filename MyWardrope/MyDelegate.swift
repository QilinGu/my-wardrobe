//
//  MyTextFieldDelegate.swift
//  MyWardrope
//
//  Created by Minh on 13.03.16.
//  Copyright © 2016 NAT. All rights reserved.
//

import Foundation
import UIKit

public class MyTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    public static let sharedInstance = MyTextFieldDelegate()
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        if (textField.text!.characters.count - range.length + string.characters.count > 125) {
            return false
        }
        return true
    }
    
}