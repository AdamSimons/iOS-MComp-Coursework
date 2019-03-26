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
        }
        
    }
    func storeDataLocally(data: Data) {
        let context = appDelegate.persistentContainer.viewContext
        
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
                try context.save()
                print("Data stored locally")
                self.resetFields()
                let alert = UIAlertController(title: "Error with connection", message: "Device can not connect to server and has saved locally", preferredStyle: UIAlertController.Style.alert);
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil));
                self.present(alert, animated: true, completion: nil);
                
            } catch {
                print("failed to save")
            }
        }
    }
    
    // MARK: - Check functions
    
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
            return true;
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
    // MARK: Rest Of Code
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Call function to get all the subjects from repository
        txtFirstName.delegate = self;
        txtLastName.delegate = self;
        txtEmail.delegate = self;
        txtSubject.delegate = self;
        txtDay.delegate = self;
        txtMonth.delegate = self;
        txtYear.delegate = self;
        
        marketingUpdateSwitch.setOn(false, animated: true)
        
        
        getSubjects();
        
        setUpSubjectPV();
        
        setUpFloatingLabels();
        
        checkLocationServices();
    }
    
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
    
    func checkLocationAuth(){
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
    
    func setUpFloatingLabels() {
        self.lblFirstName.alpha = 0;
        self.lblLastName.alpha = 0;
        self.lblEmail.alpha = 0;
        self.lblSubject.alpha = 0;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
        if lblBeingEdited.alpha == 0 {
            UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                lblBeingEdited.center.y -= 25;
                lblBeingEdited.alpha += 1;
            }, completion: nil)
            
            txtBeingEdited.placeholder = "";
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
        
        
        if txtBeingEdited.text == "" {
            UIView.animate(withDuration: 1, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                lblBeingEdited.center.y += 25;
                lblBeingEdited.alpha -= 1;
            }, completion: nil)
            
            txtBeingEdited.placeholder = lblBeingEdited.text;
        }
        textField.resignFirstResponder();
    }
    
    func setUpSubjectPV() {
        let subjectPickerView = UIPickerView(); // Set Pickerview of subjects
        
        subjectPickerView.delegate = self;
        txtSubject.delegate = self;
        
        txtSubject.inputView = subjectPickerView;
        
        let pickerViewToolbar = UIToolbar()
        pickerViewToolbar.barStyle = .default
        pickerViewToolbar.sizeToFit()
        
        let doneSubjectBtn = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(subjectDoneClick));
        
        pickerViewToolbar.setItems([doneSubjectBtn], animated: false)
        txtSubject.inputAccessoryView = pickerViewToolbar
        txtDay.inputAccessoryView = pickerViewToolbar
        txtMonth.inputAccessoryView = pickerViewToolbar
        txtYear.inputAccessoryView = pickerViewToolbar
        
//        subjectPickerView.reloadAllComponents()
    }
    
    @objc func subjectDoneClick() {
        txtDay.resignFirstResponder();
        txtMonth.resignFirstResponder();
        txtYear.resignFirstResponder();
        txtSubject.resignFirstResponder();
    }
    
    func getSubjects() {
        print("Getting Subjects")
        guard let url = URL(string: "https://prod-42.westeurope.logic.azure.com:443/workflows/bde222cb4461471d90691324f4b6861f/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=rPL5qFWfWLPKNk3KhRuP0fsw4ooSYczKXuNfCAtDjPA") else {return}
        var request = URLRequest(url: url);
        
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request){ (data,response,error) in
            guard let data = data else {return}
            do {
                print("Got Subjects")
                self.subjects = try JSONDecoder().decode([Subject].self, from: data)
                DispatchQueue.main.async {
                    self.subjects.insert(Subject.init(name: "Select Subject"), at: 0)
                }
                
//                print(self.subjects);
            } catch let jsonErr{
                print("ERROR: In decoding Subjects")
                print(jsonErr)
            }
        }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Function that limits the amount of characters for the textfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var txtField: UITextField = UITextField();
        var maxChars = 4;
        
        if textField == self.txtDay {
            txtField = self.txtDay;
            maxChars = 2;
        }
        else if textField == self.txtMonth {
            txtField = self.txtMonth;
            maxChars = 2;
        }
        else if textField == self.txtYear {
            txtField = self.txtYear;
            maxChars = 4;
        }
        
        guard let text = txtField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= maxChars;
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did update location")
        guard let location = locations.last else {return}
        self.locationCoordinate = location;
        //print(location.coordinate.latitude, location.coordinate.longitude);
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Did Local Auth")
        checkLocationAuth()
    }
    

    
    @IBAction func onClickSubmit(_ sender: Any) {
        if checkIfComplete() {
            let data = Data(
                Name: txtFirstName.text! + " " + txtLastName.text!,
                Email: txtEmail.text!,
                DOB: txtDay.text! + "/" + txtMonth.text! + "/" + txtYear.text!,
                SubjectArea: txtSubject.text!,
                MarketingUpdates: marketingUpdateSwitch.isOn,
                GpsLat: locationCoordinate?.coordinate.latitude ?? 0.0,
                GpsLon: locationCoordinate?.coordinate.longitude ?? 0.0)
            
            print(data);
            
            guard let uploadData = try? JSONEncoder().encode(data) else {return}
            print(uploadData)
            guard let url = URL(string: "https://prod-69.westeurope.logic.azure.com:443/workflows/d2ec580e6805459893e498d43f292462/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=zn8yq-Xe3cOCDoRWTiLwDsUDXAwdGSNzxKL5OUHJPxo") else {return}
            var request = URLRequest(url: url);
            
            request.httpBody = uploadData
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { (responseData, response, error) in
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        self.storeDataLocally(data: data)
                    }
                    else {
                        self.resetFields()
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
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){}
}
