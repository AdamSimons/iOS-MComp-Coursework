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
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func syncOnClick(_ sender: Any) {
        let count = datas.count
        for (index, data) in datas.enumerated() {
            guard let uploadData = try? JSONEncoder().encode(data) else {return}
            guard let url = URL(string: "https://prod-69.westeurope.logic.azure.com:443/workflows/d2ec580e6805459893e498d43f292462/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=zn8yq-Xe3cOCDoRWTiLwDsUDXAwdGSNzxKL5OUHJPxo") else {return}
            var request = URLRequest(url: url);
            
            request.httpBody = uploadData
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { (responseData, response, error) in
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        self.dataToDelete.append(data.ID)
                        print("Data \(data.ID) has been sent off")
                    }
                    print(response.statusCode)
                }
                if let error = error {
                    print(error.localizedDescription)
                }
                if (index + 1) == count {
                    DispatchQueue.main.async {
                        self.deleteEntries()
                    }
                }
            }.resume()
        }
    }
    
    func deleteEntries() {
        
        for id in dataToDelete {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RegisterDB")
            request.returnsObjectsAsFaults=false
           // request.predicate = NSPredicate(format: "id == %@", id.uuidString)
            let context = appDelegate.persistentContainer.viewContext
            
            if let result = try? context.fetch(request) {
                for object in result {
                    context.delete(object as! NSManagedObject)
                }
            }
            try? context.save()
            for (index, objects) in datas.enumerated() {
                if objects.ID == id {
                    datas.remove(at: index)
                }
            }
        }
        tableView.reloadData()
    }
    
    var datas = [Data]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("ViewDidLoad ATVC")
        tableView.delegate = self
        tableView.dataSource = self
        
        loadCoreData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        cell.textLabel?.text = datas[indexPath.row].Name
        return cell
    }
    
    func loadCoreData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RegisterDB")
        request.returnsObjectsAsFaults=false
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let dataFromDB = Data.init(
                    Name: (data.value(forKey: "name") as! String),
                    Email: (data.value(forKey: "email") as! String),
                    DOB: (data.value(forKey: "dob") as! String),
                    SubjectArea: (data.value(forKey: "subjectArea") as! String),
                    MarketingUpdates: (data.value(forKey: "marketingUpdates") as! Bool),
                    GpsLat: (data.value(forKey: "gpsLat") as! Double),
                    GpsLon: (data.value(forKey: "gpsLon") as! Double))
                
                datas.append(dataFromDB)
                
                print(dataFromDB.ID)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Query failed")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
