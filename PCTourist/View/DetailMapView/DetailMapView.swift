
//
//  DetailMapView.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/11/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import MapKit
import LifetimeTracker

class DetailMapView: UIView, LifetimeTrackable {
    static var lifetimeConfiguration = LifetimeConfiguration(maxCount: 1, groupName: "Detail Map View")
    
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        trackLifetime()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        addSubview(mapView)
        
        mapView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}
