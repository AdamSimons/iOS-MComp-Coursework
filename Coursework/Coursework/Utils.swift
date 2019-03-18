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
    
    static func checkDateIsValid(_ textDay: String, _ textMonth: String, _ textYear: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: "\(textDay)/\(textMonth)/\(textYear)")
        return date
    }
    
    static func checkLoginDetails(_ textUsername: String, _ textPassword: String) -> Bool{
        if textUsername == "ADMIN" && textPassword == "password" {
            return true
        }
        else {return false}
    }
}
