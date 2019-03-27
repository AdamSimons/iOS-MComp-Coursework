//
//  Utils.swift
//  Coursework
//
//  Created by Adam Simons on 12/03/2019.
//  Copyright © 2019 Adam Simons. All rights reserved.
//

import Foundation
import UIKit
// Class that has utility functions
class Utils {
    
    // Checks if the character count is matching
    static func checkDOBTextField(_ text: String, noOfVals: Int) -> Bool {
        if text.count == noOfVals {
            return true
        }
        else { return false }
    }
    
    // Check if a textfield is empty or not
    static func checkTextFieldComplete(_ text: String) -> Bool {
        if text != "" {
            return true
        }
        else {
            return false
        }
    }
    
    static func checkEmailIsValid(_ text: String) -> Bool {
        // Use a regex expression to check if the email address can be valid
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: text)
    }
    
    // Check if date is real
    static func checkDateIsValid(_ textDay: String, _ textMonth: String, _ textYear: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: "\(textDay)/\(textMonth)/\(textYear)")
        return date
    }
    
    // Check if date is less than today
    static func checkDateIsBeforeToday(_ date: Date) -> Bool {
        if Date() < date {
            return false
        }
        else { return true }
    }
    
    // Check if login details are correct
    static func checkLoginDetails(_ textUsername: String, _ textPassword: String) -> Bool{
        if textUsername == "Admin" && textPassword == "password" {
            return true
        }
        else {return false}
    }
    
    // Check if the subject choice is valid and not the dummy entry at row 0
    static func checkSubjectIsValid(_ text: String) -> Bool {
        if text != "Select Subject" {
            return true
        }
        else {return false}
    }
}
