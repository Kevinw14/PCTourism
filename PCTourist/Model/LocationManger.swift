//
//  LocationManger.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/27/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: CLLocationManager {
    
    override init() {
        super .init()
        self.desiredAccuracy = kCLLocationAccuracyBest
        self.requestWhenInUseAuthorization()
    }
    
    /// Finds distance between user's location to destination location in mile.
    func findDistanceToLocationInMilesString(destinationLatitude: CLLocationDegrees, destinationLongitude: CLLocationDegrees) -> String {
        guard let userLocation = LocationManager().location else { return "" }
        let destinationLocation = CLLocation(latitude: destinationLatitude, longitude: destinationLongitude)
        let distanceInMeters = destinationLocation.distance(from: userLocation)
        let miles = distanceInMeters * 0.00062137
        let milesAsString = String(format:"%.2f", miles)
        return milesAsString
    }
    
    /// Finds distance between user's location to destination location in miles.
    func findDistanceToLocationInMiles(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> Double {
        guard let userLocation = self.location else { return 0.0 }
        let destinationLocation = CLLocation(latitude: latitude, longitude: longitude)
        let distanceInMeters = destinationLocation.distance(from: userLocation)
        let miles = distanceInMeters * 0.00062137
        return miles
    }
    
    /// Finds distance between user's location to destination location in meters.
    func findDistanceToLocationInMetersString(destinationLatitude: CLLocationDegrees, destinationLongitude: CLLocationDegrees) -> String {
        guard let userLocation = LocationManager().location else { return "" }
        let destinationLocation = CLLocation(latitude: destinationLatitude, longitude: destinationLongitude)
        let distanceInMeters = destinationLocation.distance(from: userLocation)
        let metersAsString = String(format:"%.2f", distanceInMeters)
        return metersAsString
    }
    
    /// Finds distance between user's location to destination location in meters.
    func findDistanceToLocationInMeters(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> Double{
        guard let userLocation = LocationManager().location else { return 0.0 }
        let destinationLocation = CLLocation(latitude: latitude, longitude: longitude)
        let distanceInMeters = destinationLocation.distance(from: userLocation)
        return distanceInMeters
    }
}
