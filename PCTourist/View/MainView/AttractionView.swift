//
//  AttractionView.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/27/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import LifetimeTracker

class AttractionView: UIView, LifetimeTrackable {
    static var lifetimeConfiguration = LifetimeConfiguration(maxCount: 1, groupName: "Attraction View")
    
    
    var attractionController: AttractionTableViewController? {
        didSet {
            attractionController?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: mainColor]
            attractionController?.navigationItem.title = "Attractions"
            attractionController?.navigationItem.searchController = searchController
            searchController.searchBar.delegate = attractionController
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

