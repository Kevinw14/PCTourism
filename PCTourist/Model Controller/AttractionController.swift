//
//  AttractionController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/5/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import Foundation

class AttractionController {
    
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
                    let jsonDecoder = JSONDecoder()
                    let attractions = try jsonDecoder.decode([Business].self, from: data)
                    var fetchedAttractions: [Business] = []
                    for attraction in attractions {
                        fetchedAttractions.append(attraction)
                    }
                    self?.attractions = fetchedAttractions.sorted{ $0.name < $1.name}
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
        fetchAttractionsFromFB()
    }
}
