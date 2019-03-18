//
//  AdminLogin.swift
//  Coursework
//
//  Created by Adam Simons on 13/02/2019.
//  Copyright © 2019 Adam Simons. All rights reserved.
//

import Foundation
import UIKit

class AdminLoginClass: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func loginOnClick(_ sender: Any) {
        if Utils.checkLoginDetails(txtUsername.text!, txtPassword.text!) {
            performSegue(withIdentifier: "segueToATVC", sender: nil)
        }
        else {
            let alert = UIAlertController(title: "Incorrect details", message: "Username or password are incorrect", preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil));
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    
    struct LoginDetails {
        let username: String
        let password: String
    };
    
    let adminDetails = LoginDetails(username: "Admin", password: "password")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtUsername.text = ""
        txtPassword.text = ""
    }
    
//    func checkLoginDetails() -> Bool {
//        if txtUsername.text == adminDetails.username && txtPassword.text == adminDetails.password {
//            return true;
//        }
//        else { return false }
//    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        txtUsername.text = ""
        txtPassword.text = ""
    }
}
