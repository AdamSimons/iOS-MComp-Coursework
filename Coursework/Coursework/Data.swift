//
//  Data.swift
//  Coursework
//
//  Created by Adam Simons on 13/02/2019.
//  Copyright © 2019 Adam Simons. All rights reserved.
//

import Foundation
// Class structure to encode later with JSON
class Data : Codable {
    let ID: UUID // Identifier key used to make sure all the records are unique
    let Name: String
    let Email: String
    let DOB: String
    let SubjectArea: String
    let MarketingUpdates: Bool
    let GpsLat: Double
    let GpsLon: Double
    
    init(Name: String, Email: String, DOB: String, SubjectArea: String, MarketingUpdates: Bool, GpsLat: Double, GpsLon: Double) {
        self.Name = Name
        self.Email = Email
        self.DOB = DOB
        self.SubjectArea = SubjectArea
        self.MarketingUpdates = MarketingUpdates
        self.GpsLat = GpsLat
        self.GpsLon = GpsLon
        
        self.ID = UUID.init() // Genereate random ID
    }
}
