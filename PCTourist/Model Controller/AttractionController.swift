//
//  AttractionController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/5/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import Foundation
import LifetimeTracker

class AttractionController: LifetimeTrackable {
    static var lifetimeConfiguration = LifetimeConfiguration(maxCount: 1, groupName: "Attraction Controller")
    
    
    //MARK: - Private Keys
    
    enum NotificationKeys {
        static let updateTable = Notification.Name("updateTable")
    }
    //MARK: - Properties
    
    static let shared = AttractionController()
    
    private let baseURL = URL(string: "https://pctours-50784.firebaseio.com/")
    
    var attractions: [Business] = [] {
        didSet {
            NotificationCenter.default.post(name: NotificationKeys.updateTable, object: self)
        }
    }
    
    //MARK: - Private Functions
    
    private func fetchAttractionsFromFB() {
        guard let url = baseURL?.appendingPathComponent("attractions").appendingPathExtension("json") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                print("Error in \(#function) Data Task: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    guard let jsonDictionaryArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] else { return }
                    var fetchedAttractions: [Business] = []
                    for jsonDictionary in jsonDictionaryArray {
                        guard let attraction = Business(jsonDictionary: jsonDictionary) else { return }
                        fetchedAttractions.append(attraction)
                    }
                    DispatchQueue.main.async {
                        self?.attractions = fetchedAttractions.sorted(by: {$0.name < $1.name})
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
        fetchAttractionsFromFB()
        trackLifetime()
    }
}
