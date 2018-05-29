//
//  RestaurantController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/4/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import Foundation
import LifetimeTracker

class RestaurantController: LifetimeTrackable {
    
    static var lifetimeConfiguration = LifetimeConfiguration(maxCount: 1, groupName: "Restaurant Controller")
    
    //MARK: - Private Keys
    
    enum NotificationKeys {
        static let updateTable = Notification.Name("updateTable")
    }
    
    //MARK: - Properties
    
    //Shared Instance
    static let shared = RestaurantController()
    
    //Base URL to get restaurant's ID
    private let baseURL = URL(string: "https://pctours-50784.firebaseio.com/")
    
    var restaurants: [Business] = [] {
        didSet {
            NotificationCenter.default.post(name: RestaurantController.NotificationKeys.updateTable, object: self)
        }
    }
    
    //MARK: - Load From FB
    
    private func fetchRestaurants() {
        guard let url = baseURL?.appendingPathComponent("restaurants").appendingPathExtension("json") else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            if let error = error {
                print("Error in FetchRestaurant Data Task: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    guard let jsonDictionaryArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]] else { return }
                    var fetchedRestaurants: [Business] = []
                    for jsonDictionary in jsonDictionaryArray {
                        guard let restaurant = Business(jsonDictionary: jsonDictionary) else { return }
                        fetchedRestaurants.append(restaurant)
                    }
                    DispatchQueue.main.async {
                        self?.restaurants = fetchedRestaurants.sorted(by: {$0.name < $1.name})
                    }
                } catch {
                    print("Error in Serialization: \(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchRestaurantImages(url: String, completion: @escaping(UIImage?) -> Void) {
        guard let imageUrl = URL(string: url) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: imageUrl) { (data, _, error) in
            if let error = error {
                print("Error in image data task: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            }
        }
        dataTask.resume()
    }
    
    //MARK: - Initilization
    
    private init() {
        fetchRestaurants()
        trackLifetime()
    }
}
