//
//  RestaurantTableViewController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/3/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation
import LifetimeTracker
import SkeletonView

private let reuseIdentifier = "RestaurantCell"

class RestaurantTableViewController: UITableViewController, LifetimeTrackable {
    
    static var lifetimeConfiguration = LifetimeConfiguration(maxCount: 1, groupName: "Restaurant Table View Controller")
    
    
    //MARK: - Properties
    
    var filteredRestaurants: [Business] = []
    let restaurantView = RestaurantView()
    var isSearchActive = false
    var restaurantLocationManager = LocationManager()
    let lightHapticGenerator = UIImpactFeedbackGenerator(style: .light)
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Private Functions
    
    @objc private func updateTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.stopSkeletonAnimation()
            self.view.hideSkeleton()
        }
    }
    
    private func setupView() {
        restaurantView.restaurantController = self
        restaurantLocationManager.delegate = self
        tableView.rowHeight = 235
        self.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.showAnimatedGradientSkeleton()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: RestaurantController.NotificationKeys.updateTable, object: nil)
    }
}

//MARK: - Search Bar Delegate

extension RestaurantTableViewController: UISearchBarDelegate {
    
    //Searches for restaurant using name.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRestaurants = RestaurantController.shared.restaurants.filter({ (restaurant) -> Bool in
           return restaurant.name.lowercased().contains(searchText.lowercased())
        })
        
        switch filteredRestaurants.count {
        case 0: isSearchActive = false
        default: isSearchActive = true
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchActive = false
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        tableView.reloadData()
    }
}

//MARK: - Location Manager Delegate

extension RestaurantTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        tableView.reloadData()
    }
    
}

// MARK: - Table view data source

extension RestaurantTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredRestaurants.count : RestaurantController.shared.restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        //Gets restaurant depending on whether a search is taking place.
        let restaurant = isSearchActive ? filteredRestaurants[indexPath.row] : RestaurantController.shared.restaurants[indexPath.row]
        
        //Sets up the cell's view.
        cell.nameLabel.text = restaurant.name
        cell.mainImageView.kf.setImage(with: URL(string: restaurant.imageURL))
        cell.addressLabel.text = "\(restaurant.address), \(restaurant.city), \(restaurant.state), \(restaurant.postal)"
        
        //Determines if location services are in use. Hides or shows milage depening if it's in use.
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            cell.distanceLabel.isHidden = false
            cell.distanceLabel.text = "\(restaurantLocationManager.findDistanceToLocationInMilesString(destinationLatitude: restaurant.location.latitude, destinationLongitude: restaurant.location.longitude))mi"
        default: cell.distanceLabel.isHidden = true
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailTableViewController = DetailTableViewController(style: .grouped)
        let currentRestaurant = isSearchActive ? filteredRestaurants[indexPath.row] : RestaurantController.shared.restaurants[indexPath.row]
        detailTableViewController.currentBusiness = currentRestaurant
        lightHapticGenerator.impactOccurred()
        navigationController?.pushViewController(detailTableViewController, animated: true)
    }
}
