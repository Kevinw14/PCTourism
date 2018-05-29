//
//  PlaceController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/5/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import Foundation
import LifetimeTracker

class PlaceController: LifetimeTrackable {
    static var lifetimeConfiguration = LifetimeConfiguration(maxCount: 1, groupName: "Place Controller")
    
    
    //MARK: - Private Keys
    
    enum NotificationKeys {
        static let reloadTable = Notification.Name("updateTable")
    }
    //MARK: - Properties
    
    static let shared = PlaceController()
    
    private let baseURL = URL(string: "https://pctours-50784.firebaseio.com/")
    
    var places: [Business] = [] {
        didSet {
          NotificationCenter.default.post(name: PlaceController.NotificationKeys.reloadTable, object: self)
        }
    }
    
    //MARK: - Private Functions
    
    private func fetchPlacesFromFB() {
        guard let url = baseURL?.appendingPathComponent("housing").appendingPathExtension("json") else { return }
        
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                print("Error in \(#function) Data Task: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    guard let jsonDictionaryArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] else { return }
                    var fetchedPlaces: [Business] = []
                    for jsonDictionary in jsonDictionaryArray {
                        guard let place = Business(jsonDictionary: jsonDictionary) else { return }
                        fetchedPlaces.append(place)
                    }
                    DispatchQueue.main.async {
                        self?.places = fetchedPlaces.sorted(by: {$0.name < $1.name})
                    }
                } catch {
                    print("Error in Serialization: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
    //MARK: - Initilization
    
    private init() {
        fetchPlacesFromFB()
        trackLifetime()
    }
}
