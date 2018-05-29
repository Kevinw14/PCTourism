//
//  PlaceView.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/27/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import LifetimeTracker

class PlaceView: UIView, LifetimeTrackable {
    static var lifetimeConfiguration: LifetimeConfiguration = LifetimeConfiguration(maxCount: 1, groupName: "Place View")
    
    var placeController: PlacesTableViewController? {
        didSet {
            placeController?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: mainColor]
            placeController?.navigationItem.title = "Accommodations"
            placeController?.navigationItem.searchController = searchController
            searchController.searchBar.delegate = placeController
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
