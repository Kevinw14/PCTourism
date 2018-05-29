//
//  NearbyController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/26/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import Foundation
import LifetimeTracker
import CoreLocation

class NearbyController: LifetimeTrackable {
    static var lifetimeConfiguration = LifetimeConfiguration(maxCount: 1, groupName: "Nearby Controller")
    
    
    //MARK: - Private Keys
    
    enum NotificationKeys {
        static let updateTable = Notification.Name("updateTable")
    }
    //MARK: - Properties
    
    static let shared = NearbyController()
    
    private let baseUrl = "https://pctours-50784.firebaseio.com/"
    var nearbyLocations: [Business] = [] {
        didSet {
            NotificationCenter.default.post(name: NearbyController.NotificationKeys.updateTable, object: self)
        }
    }
    
    var radius = 5.0
    
    private var allLocations:[Business] = []
    
    //MARK: - Private Functions
    
    private func fetchAllLocations() {
        guard let url = URL(string: baseUrl)?.appendingPathExtension("json") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error in fetchAllLocations Data Task: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else { return }
                    var fetchedBusinesses: [Business] = []
                    jsonDictionary.forEach({ (_, value) in
                        guard let businessDictionaries = value as? [[String:Any]] else { return }
                        for businessDictionary in businessDictionaries {
                            guard let business = Business(jsonDictionary: businessDictionary) else { return }
                            fetchedBusinesses.append(business)
                        }
                    })
                    DispatchQueue.main.async {
                        self.allLocations = fetchedBusinesses
                        self.fetchNearbyLocations()
                    }
                } catch {
                    print("Error in fetchAllLocation data: \(error.localizedDescription)")
                    return
                }
            }
        }
        dataTask.resume()
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
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            fetchAllLocations()
        default: break
        }
        trackLifetime()
    }
}
