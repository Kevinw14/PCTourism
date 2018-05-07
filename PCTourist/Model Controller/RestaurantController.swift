//
//  RestaurantController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/4/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import Foundation

class RestaurantController {
    
    
    
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
                    let jsonDecoder = JSONDecoder()
                    let restaurantArray = try jsonDecoder.decode([Business].self, from: data)
                    self?.restaurants = restaurantArray.sorted(by: {$0.name < $1.name})
                } catch {
                    print("Error in FetchRestaurant Data: \(error.localizedDescription)")
                    return
                }
            }
        }
        dataTask.resume()
    }
    
    //MARK: - Initilization
    
    private init() {
        fetchRestaurants()
    }
}
