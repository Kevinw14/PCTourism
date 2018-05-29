//
//  RestaurantView.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/5/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import LifetimeTracker

class NearbyView: UIView, LifetimeTrackable {
    static var lifetimeConfiguration = LifetimeConfiguration(maxCount: 1, groupName: "Nearby View")
    
    
    //MARK: - Properties
    
    var nearbyTableViewController: NearbyTableViewController? {
        didSet {
            nearbyTableViewController?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: mainColor]
            nearbyTableViewController?.navigationItem.title = "Nearby"
            nearbyTableViewController?.tableView.refreshControl = nearbyRefreshControl
            nearbyTableViewController?.navigationController?.navigationBar.tintColor = mainColor
            nearbyTableViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "NearbySettings").withRenderingMode(.alwaysTemplate), style: .done, target: nearbyTableViewController, action: #selector(nearbyTableViewController?.nearbySettings))
        }
    }
    
    let nearbyRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        trackLifetime()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
