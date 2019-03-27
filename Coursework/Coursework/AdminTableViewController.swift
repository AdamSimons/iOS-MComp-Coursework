//
//  AdminTableViewController.swift
//  Coursework
//
//  Created by Adam Simons on 13/02/2019.
//  Copyright © 2019 Adam Simons. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AdminTableViewController:  UIViewController,
UITableViewDelegate, UITableViewDataSource {
    
    var dataToDelete = [UUID]()
    var tableData = [Data]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("ViewDidLoad ATVC")
        tableView.delegate = self
        tableView.dataSource = self
        // Load the data
        loadCoreData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadCoreData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RegisterDB") // get the correct DB
        request.returnsObjectsAsFaults=false
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] { // get the data from the table via names of the columns
                let dataFromDB = Data.init(
                    Name: (data.value(forKey: "name") as! String),
                    Email: (data.value(forKey: "email") as! String),
                    DOB: (data.value(forKey: "dob") as! String),
                    SubjectArea: (data.value(forKey: "subjectArea") as! String),
                    MarketingUpdates: (data.value(forKey: "marketingUpdates") as! Bool),
                    GpsLat: (data.value(forKey: "gpsLat") as! Double),
                    GpsLon: (data.value(forKey: "gpsLon") as! Double))
                
                tableData.append(dataFromDB) // place in array
                
                print(dataFromDB.ID)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData() // Reload the table with the new data
            }
        } catch {
            print("Query failed")
        }
    }
    
    // On Sync click
    @IBAction func syncOnClick(_ sender: Any) {
        let count = tableData.count // get count
        for (index, data) in tableData.enumerated() { // enumerate through the array
            guard let uploadData = try? JSONEncoder().encode(data) else {return}
            guard let url = URL(string: "https://prod-69.westeurope.logic.azure.com:443/workflows/d2ec580e6805459893e498d43f292462/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=zn8yq-Xe3cOCDoRWTiLwDsUDXAwdGSNzxKL5OUHJPxo") else {return}
            var request = URLRequest(url: url);
            
            request.httpBody = uploadData
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { (responseData, response, error) in
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        self.dataToDelete.append(data.ID) // if upload successful place in another array to be deleted
                        print("Data \(data.ID) has been sent off")
                    }
                    print(response.statusCode)
                }
                if let error = error {
                    print(error.localizedDescription)
                }
                if (index + 1) == count { // Once all the data has been sent then delete
                    DispatchQueue.main.async {
                        self.deleteEntries()
                    }
                }
            }.resume()
        }
    }
    
    // Delete all the data that has been synced from the local DB
    func deleteEntries() {
        for id in dataToDelete { // Using the UUID
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RegisterDB")
            request.returnsObjectsAsFaults=false
            let context = appDelegate.persistentContainer.viewContext
            
            if let result = try? context.fetch(request) {
                for object in result { // Remove DB entries that match the deletion array entries
                    context.delete(object as! NSManagedObject)
                }
            }
            try? context.save()
            for (index, objects) in tableData.enumerated() { // Delete the data from the table data
                if objects.ID == id {
                    tableData.remove(at: index)
                }
            }
        }
        tableView.reloadData() // reload the table view
    }
    
    // MARK: Table view delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row].Name // place name in the row of the table view
        return cell
    }
    

}
