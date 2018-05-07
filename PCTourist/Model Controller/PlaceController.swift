//
//  PlaceController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/5/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import Foundation

class PlaceController {
    
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
                    let jsonDecoder = JSONDecoder()
                    let places = try jsonDecoder.decode([Business].self, from: data)
                    var fetchedPlaces: [Business] = []
                    for place in places {
                        fetchedPlaces.append(place)
                    }
                    self?.places = fetchedPlaces.sorted{ $0.name < $1.name}
                } catch {
                    print("Error in \(#function) Data: \(error.localizedDescription)")
                    return
                }
            }
        }
        dataTask.resume()
    }
    
    //MARK: - Initilization
    
    private init() {
        fetchPlacesFromFB()
    }
}
