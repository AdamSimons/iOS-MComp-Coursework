//
//  ViewController.swift
//  Coursework
//
//  Created by Adam Simons on 06/02/2019.
//  Copyright © 2019 Adam Simons. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import CoreData 

class ViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Connect all my UI elements
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var txtSubject: UITextField!
    
    @IBOutlet weak var txtDay: UITextField!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var marketingUpdateSwitch: UISwitch!
    
    // Set up the location manager
    let locationManager = CLLocationManager();
    let regionMeters: Double = 10000
    
    var locationCoordinate: CLLocation?;
    
    // Create a struct for decoding of subjects later
    var subjects = [Subject]();
    struct Subject: Decodable {
        let name: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set all the delegates up
        txtFirstName.delegate = self;
        txtLastName.delegate = self;
        txtEmail.delegate = self;
        txtSubject.delegate = self;
        txtDay.delegate = self;
        txtMonth.delegate = self;
        txtYear.delegate = self;
        
        // Turn all the labels invisible
        lblFirstName.alpha = 0;
        lblLastName.alpha = 0;
        lblEmail.alpha = 0;
        lblSubject.alpha = 0;
        
        // Default switch to false
        marketingUpdateSwitch.setOn(false, animated: true)
        // Call function to get all the subjects from repository
        getSubjects();
        // Setup the picker view for the subject selection
        setUpSubjectPV();
        // Check the location services are on
        checkLocationServices();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions done in viewDidLoad()
    func setUpSubjectPV() {
        let subjectPickerView = UIPickerView(); // Set Pickerview of subjects
        
        subjectPickerView.delegate = self;
        //        txtSubject.delegate = self;
        // Change the input to be the picker
        txtSubject.inputView = subjectPickerView;
        
        // Set up toolbar for a done button
        let pickerViewToolbar = UIToolbar()
        pickerViewToolbar.barStyle = .default
        pickerViewToolbar.sizeToFit()
        // Initialise done button
        let doneSubjectBtn = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonClick));
        // Place button on toolbar
        pickerViewToolbar.setItems([doneSubjectBtn], animated: false)
        // Place toolbars on each of these inputs
        txtSubject.inputAccessoryView = pickerViewToolbar
        txtDay.inputAccessoryView = pickerViewToolbar
        txtMonth.inputAccessoryView = pickerViewToolbar
        txtYear.inputAccessoryView = pickerViewToolbar
    }
    
    // Done buttons function
    @objc func onDoneButtonClick() {
        txtDay.resignFirstResponder();
        txtMonth.resignFirstResponder();
        txtYear.resignFirstResponder();
        txtSubject.resignFirstResponder();
    }
    
    // Pull subjects from a JSON repository
    func getSubjects() {
        print("Getting Subjects")
        guard let url = URL(string: "https://prod-42.westeurope.logic.azure.com:443/workflows/bde222cb4461471d90691324f4b6861f/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=rPL5qFWfWLPKNk3KhRuP0fsw4ooSYczKXuNfCAtDjPA") else {return}
        var request = URLRequest(url: url);
        
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data else {return}
            do {
                print("Got Subjects")
                self.subjects = try JSONDecoder().decode([Subject].self, from: data) // Decode
                DispatchQueue.main.async {
                    self.subjects.insert(Subject.init(name: "Select Subject"), at: 0) // Place a dummy in the first box
                }
            } catch let jsonErr{
                print("ERROR: In decoding Subjects")
                print(jsonErr)
            }
            }.resume()
    }
    // Check if location services are set up
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() { // Ask the Loc Man if the location services are enabled
            setUpLocationManager() // Set up location manager
            checkLocationAuth() // check the location authorization for the app
        }
        else {
            // Show alert to say turn on location
            let alert = UIAlertController(title: "Location Services", message: "Your location services are turned off", preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil));
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    // MARK: - Check functions
    // Using the utility class to check all the dates correctly
    func checkAllTextFields() -> Bool {
        return Utils.checkTextFieldComplete(txtFirstName.text!) && Utils.checkTextFieldComplete(txtLastName.text!) && Utils.checkTextFieldComplete(txtEmail.text!) && Utils.checkTextFieldComplete(txtSubject.text!)
    }
    // Checks all the DOB fields and returns either a true or false
    func checkAllDOBTextFields() -> Bool {
        return Utils.checkDOBTextField(txtDay.text!, noOfVals: 2) && Utils.checkDOBTextField(txtMonth.text!, noOfVals: 2) && Utils.checkDOBTextField(txtYear.text!, noOfVals: 4)
    }
    // Check if the date is plausible so 01/01/2000 is true 32/13/2000 is not
    func checkDateIsValid(_ textFieldDay: UITextField, _ textFieldMonth: UITextField, _ textFieldYear: UITextField) -> Bool {
        if (Utils.checkDateIsValid(textFieldDay.text!, textFieldMonth.text!, textFieldYear.text!) != nil) {
            // Check is date is plausible
            if checkDateIsInPast(textFieldDay.text!, textFieldMonth.text!, textFieldYear.text!) {
               return true
            }
            else { return false }
        }
        else {
            let alert = UIAlertController(title: "Incorrect date" , message: "The date provided does not exist", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false;
        }
    }
    // Checks using regex to see if an email address is valid
    func checkEmailIsValid(_ textField: UITextField) -> Bool {
        if Utils.checkEmailIsValid(textField.text!) {
            return true
        }
        else {
            let alert = UIAlertController(title: "Incorrect email format" , message: "The email address provided is in the correct format", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false;
        }
    }
    // Check if the subject has been correctly chosen
    func checkSubjectIsValid(_ textField: UITextField) -> Bool {
        if Utils.checkSubjectIsValid(textField.text!) {
            return true
        }
        else {
            let alert = UIAlertController(title: "Incorrect Subject" , message: "A valid subject must be selected", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false;
        }
    }
    // Check if DOB is before today
    func checkDateIsInPast(_ textDay: String, _ textMonth: String, _ textYear: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: "\(textDay)/\(textMonth)/\(textYear)")
        
        if Utils.checkDateIsBeforeToday(date!) {
            return true
        }
        else {
            let alert = UIAlertController(title: "Incorrect date" , message: "The date provided is in the future and is not possible for a date of birth", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false;
        }
    }
    // The function that runs all the check statements
    func checkIfComplete() -> Bool {
        if checkAllTextFields() && checkAllDOBTextFields()
        {
            if checkEmailIsValid(txtEmail) && checkDateIsValid(txtDay, txtMonth, txtYear) && checkSubjectIsValid(txtSubject){
                return true;
            }
            else {return false}
        }
        else {
            let alert = UIAlertController(title: "Incomplete Data", message: "You can not submit data whilst fields are incomplete", preferredStyle: UIAlertController.Style.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil));
            self.present(alert, animated: true, completion: nil);
            return false;
        }
    }
    
    // MARK: Picker view methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjects.count;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjects[row].name;
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtSubject.text = subjects[row].name;
    }
    
    // MARK: Location Services
    func checkLocationAuth() {
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse: // Authorized when this app is in the foreground
            print("Showing location in use")
            locationManager.startUpdatingLocation()
            break
        case .denied: // authorization to use location services for this app have been denied
            break
        case .notDetermined: // the user has not set the permission
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted: // the user has not able to set e.g. a child using a parental controlled devices
            break
        case .authorizedAlways: // enabled always, even if the app is in the background
            print("Showing location always")
            locationManager.startUpdatingLocation()
        }
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self; // tells the location manager where to recieve update events
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; // set the accuracy to best
        locationManager.distanceFilter = 100.0;
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did update location")
        guard let location = locations.last else {return}
        self.locationCoordinate = location; // sets the location to the local variable
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Did Local Auth")
        checkLocationAuth()
    }
    
    // MARK: Textfield functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var txtBeingEdited: UITextField = UITextField();
        var lblBeingEdited: UILabel = UILabel();
        // Get the correct textfield
        if textField == self.txtFirstName {
            txtBeingEdited = self.txtFirstName;
            lblBeingEdited = self.lblFirstName;
        }
        else if textField == self.txtLastName {
            txtBeingEdited = self.txtLastName;
            lblBeingEdited = self.lblLastName;
        }
        else if textField == self.txtEmail {
            txtBeingEdited = self.txtEmail;
            lblBeingEdited = self.lblEmail;
        }
        else if textField == self.txtSubject {
            txtBeingEdited = self.txtSubject;
            lblBeingEdited = self.lblSubject;
        }
        // Moves label animation
        if lblBeingEdited.alpha == 0 {
            UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                lblBeingEdited.center.y -= 25; // Move up
                lblBeingEdited.alpha += 1; // become visible
            }, completion: nil)
            
//            txtBeingEdited.placeholder = ;
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        var txtBeingEdited: UITextField = UITextField();
        var lblBeingEdited: UILabel = UILabel();
        
        if textField == self.txtFirstName {
            txtBeingEdited = self.txtFirstName;
            lblBeingEdited = self.lblFirstName;
        }
        else if textField == self.txtLastName {
            txtBeingEdited = self.txtLastName;
            lblBeingEdited = self.lblLastName;
        }
        else if textField == self.txtEmail {
            txtBeingEdited = self.txtEmail;
            lblBeingEdited = self.lblEmail;
        }
        else if textField == self.txtSubject {
            txtBeingEdited = self.txtSubject;
            lblBeingEdited = self.lblSubject;
        }
        // If the text field that finished editing didn't contain any text then animate labels back
        if txtBeingEdited.text == "" {
            UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                lblBeingEdited.center.y += 25;
                lblBeingEdited.alpha -= 1;
            }, completion: nil)
            
            txtBeingEdited.placeholder = lblBeingEdited.text;
        }
        textField.resignFirstResponder();
    }
    
    // Resign first responder when pressing enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // Function that limits the amount of characters for the textfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var txtField: UITextField = UITextField();
        var maxChars = 4;
        // 2 for day
        if textField == self.txtDay {
            txtField = self.txtDay;
            maxChars = 2;
        } // 2 for month
        else if textField == self.txtMonth {
            txtField = self.txtMonth;
            maxChars = 2;
        } // 4 for year
        else if textField == self.txtYear {
            txtField = self.txtYear;
            maxChars = 4;
        }
        
        // limits the text
        guard let text = txtField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= maxChars;
    }
    
    // MARK: Submitting functions
    @IBAction func onClickSubmit(_ sender: Any) {
        if checkIfComplete() { // If all checks are complete then encode data
            let data = Data(
                Name: txtFirstName.text! + " " + txtLastName.text!,
                Email: txtEmail.text!,
                DOB: txtDay.text! + "/" + txtMonth.text! + "/" + txtYear.text!,
                SubjectArea: txtSubject.text!,
                MarketingUpdates: marketingUpdateSwitch.isOn,
                GpsLat: locationCoordinate?.coordinate.latitude ?? 0.0,
                GpsLon: locationCoordinate?.coordinate.longitude ?? 0.0)
            
            print(data);
            
            guard let uploadData = try? JSONEncoder().encode(data) else {return} // encode
            print(uploadData)
            guard let url = URL(string: "https://prod-69.westeurope.logic.azure.com:443/workflows/d2ec580e6805459893e498d43f292462/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=zn8yq-Xe3cOCDoRWTiLwDsUDXAwdGSNzxKL5OUHJPxo") else {return}
            var request = URLRequest(url: url);
            
            request.httpBody = uploadData
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { (responseData, response, error) in
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 { // If an error has occured then store locally
                        self.storeDataLocally(data: data)
                    }
                    else {
                        self.resetFields() // Clear fields if sent successfully
                    }
                    print(response.statusCode)
                }
                
                if let responseData = responseData {
                    print(responseData)
                }
                if let error = error {
                    print(error.localizedDescription)
                    self.storeDataLocally(data: data)
                }
                }.resume()
            
        }
    }
    // Once the data has been sent reset fields to empty
    func resetFields() {
        DispatchQueue.main.async {
            self.txtFirstName.text = ""
            self.txtLastName.text = ""
            self.txtEmail.text = ""
            self.txtSubject.text = ""
            self.txtDay.text = ""
            self.txtMonth.text = ""
            self.txtYear.text = ""
            self.marketingUpdateSwitch.setOn(false, animated: true)
            
            // Animate labels back to starting positions
            UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.lblFirstName.center.y += 25;
                self.lblFirstName.alpha -= 1;
                self.lblLastName.center.y += 25;
                self.lblLastName.alpha -= 1;
                self.lblEmail.center.y += 25;
                self.lblEmail.alpha -= 1;
                self.lblSubject.center.y += 25;
                self.lblSubject.alpha -= 1;
            }, completion: nil)
        }
    }
    
    // Used to store all the data locally if a network error
    func storeDataLocally(data: Data) {
        let context = appDelegate.persistentContainer.viewContext
        
        // Save values to the table
        context.perform {
            let entity = NSEntityDescription.entity(forEntityName: "RegisterDB", in: context)
            let newEntity = NSManagedObject.init(entity: entity!, insertInto: context)
            
            newEntity.setValue(data.ID, forKey: "id")
            newEntity.setValue(data.Name, forKey: "name")
            newEntity.setValue(data.Email, forKey: "email")
            newEntity.setValue(data.DOB, forKey: "dob")
            newEntity.setValue(data.SubjectArea, forKey: "subjectArea")
            newEntity.setValue(data.MarketingUpdates, forKey: "marketingUpdates")
            newEntity.setValue(data.GpsLat, forKey: "gpsLat")
            newEntity.setValue(data.GpsLon, forKey: "gpsLon")
            
            do {
                try context.save() // try to save
                print("Data stored locally")
                self.resetFields() // Reset the fields
                // Print message to user
                let alert = UIAlertController(title: "Error with connection", message: "Device can not connect to server and has saved locally", preferredStyle: UIAlertController.Style.alert);
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil));
                self.present(alert, animated: true, completion: nil);
                
            } catch {
                print("failed to save")
            }
        }
    }
    // To unwind from the Admin login screen
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){}
}
