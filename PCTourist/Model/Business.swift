//
//  Business.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/26/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import Foundation

struct Business: Codable {
    
    let name: String
    let address: String
    let city: String
    let state: String
    let postal: String
    let phoneNumber: String?
    let category: String
    let imageURL: String
    let wifi: String?
    let twitter: String?
    let instagram: String?
    let payment: String?
    let hours: Hours?
    let airConditioned: String?
    let location: Location
    let airbnb: String?
    var distance: Double {
            let locationManager = LocationManager()
            return locationManager.findDistanceToLocationInMiles(latitude: location.latitude, longitude: location.longitude)
    }
    
    init?(jsonDictionary: [String:Any]) {
        guard let name = jsonDictionary["name"] as? String,
            let address = jsonDictionary["address"] as? String,
            let city = jsonDictionary["city"] as? String,
            let state = jsonDictionary["state"] as? String,
            let postal = jsonDictionary["postal"] as? String,
            let category = jsonDictionary["category"] as? String,
            let imageURL = jsonDictionary["imageURL"] as? String,
            let locationDictionary = jsonDictionary["location"] as? [String:Any],
            let location = Location(jsonDictionary: locationDictionary) else { return nil }
        
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.postal = postal
        self.phoneNumber = jsonDictionary["phoneNumber"] as? String
        self.category = category
        self.imageURL = imageURL
        self.wifi = jsonDictionary["wifi"] as? String
        self.twitter = jsonDictionary["twitter"] as? String
        self.instagram = jsonDictionary["instagram"] as? String
        self.payment = jsonDictionary["payment"] as? String
        self.airConditioned = jsonDictionary["airConditioned"] as? String
        self.location = location
        self.airbnb = jsonDictionary["airbnb"] as? String
        self.hours = Hours(jsonDictionary: jsonDictionary["hours"] as? [String:Any] ?? ["":""])
    }
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    init?(jsonDictionary: [String:Any]) {
        guard let latitude = jsonDictionary["latitude"] as? Double, let longitude = jsonDictionary["longitude"] as? Double else { return nil }
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct Hours: Codable {
    let hours: String?
    
    init?(jsonDictionary: [String:Any]) {
        let todaysHours = jsonDictionary[dayOfWeek().lowercased()] as? String
        self.hours = todaysHours
    }
}
