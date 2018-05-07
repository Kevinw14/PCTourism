//
//  DetailMapViewController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/15/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import MapKit

class DetailMapViewController: UIViewController {
    
    //MARK: - Properties
    
    var restaurantDetailMapView = DetailMapView(frame: UIScreen.main.bounds)
    var currentBusiness: Business?
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super .viewDidLoad()
        view.addSubview(restaurantDetailMapView)
        restaurantDetailMapView.mapView.showsUserLocation = true
        showLocationOnMap()
    }
    
    //MARK: - Private Functions
    
    private func showLocationOnMap() {
        guard let latitude = currentBusiness?.location.latitude, let longitude = currentBusiness?.location.longitude else { return }
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let annotation = MKPointAnnotation()
        annotation.title = currentBusiness?.name
        annotation.coordinate = coordinate
        restaurantDetailMapView.mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.005, 0.005))
        restaurantDetailMapView.mapView.setRegion(region, animated: true)
    }
}
