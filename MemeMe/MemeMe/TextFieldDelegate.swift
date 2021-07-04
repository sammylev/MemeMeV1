//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by Sammy Murray on 6/29/21.
//

import Foundation
import UIKit

class memeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    let memeTextAttributes = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : -3.0 ] as [NSAttributedString.Key : Any]
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        return true
    }
    
    func initializeText (_ textField: UITextField, defaultText: String) {
        textField.text = defaultText
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // check for and clear default text
        if textField.text == "Top Text" && textField.tag == 0 {
            textField.text = ""
        }
        else if textField.text == "Bottom Text" && textField.tag == 1 {
            textField.text = "Top Text"
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
