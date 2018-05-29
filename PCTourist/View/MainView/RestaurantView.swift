//
//  RestaurantView.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/27/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import LifetimeTracker

class RestaurantView: UIView, LifetimeTrackable {
    
    static var lifetimeConfiguration = LifetimeConfiguration(maxCount: 1, groupName: "Restaurant View")
    
    
    var restaurantController: RestaurantTableViewController? {
        didSet {
            restaurantController?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: mainColor]
            restaurantController?.navigationItem.title = "Restaurants"
            restaurantController?.navigationItem.searchController = searchController
            searchController.searchBar.delegate = restaurantController
        }
    }
    
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = true
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = true
        return searchController
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        trackLifetime()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

