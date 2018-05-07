//
//  NearbyController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/26/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import Foundation
import FirebaseDatabase

class NearbyController {
    
    //MARK: - Private Keys
    
    enum NotificationKeys {
        static let updateTable = Notification.Name("updateTable")
    }
    //MARK: - Properties
    
    static let shared = NearbyController()
    
    var nearbyLocations: [Business] = [] {
        didSet {
            NotificationCenter.default.post(name: NearbyController.NotificationKeys.updateTable, object: self)
        }
    }
    
    var radius = 5.0
    
    private var allLocations:[Business] = []
    
    //MARK: - Private Functions
    private func fetchAllLocations() {
        Database.database().reference().observeSingleEvent(of: .value) { [weak self] (snapshot) in
            var fetchedAllLocations: [Business] = []
            if let dictionaries = snapshot.children.allObjects as? [DataSnapshot] {
                for dictionary in dictionaries {
                    guard let jsonDictionaryArray = dictionary.value as? [[String:Any]] else { return }
                    for jsonDictionary in jsonDictionaryArray {
                        guard let business = Business(jsonDictionary: jsonDictionary) else { return }
                        fetchedAllLocations.append(business)
                    }
                }
                self?.allLocations = fetchedAllLocations
                self?.fetchNearbyLocations()
            }
        }
    }
    
    @objc func fetchNearbyLocations() {
        var fetchedNearbyLocations: [Business] = []
        let locationManager = LocationManager()
        for location in self.allLocations {
            let distance = locationManager.findDistanceToLocationInMiles(latitude: location.location.latitude, longitude: location.location.longitude)
            if distance <= radius {
                fetchedNearbyLocations.append(location)
            }
        }
        self.nearbyLocations = fetchedNearbyLocations.sorted(by: {$0.distance < $1.distance})
    }
    
    private init() {
        fetchAllLocations()
    }
}
