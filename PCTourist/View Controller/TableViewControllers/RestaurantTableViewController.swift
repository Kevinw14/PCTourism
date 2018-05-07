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

private let reuseIdentifier = "RestaurantCell"

//Red
//let mainColor = UIColor(red: 244/255, green: 24/255, blue: 0/255, alpha: 1.0)
//Blue
//let mainColor = UIColor(red: 14/255, green: 121/255, blue: 178/255, alpha: 1.0)
//Tart Orange
//let mainColor = UIColor(red: 254/255, green: 74/255, blue: 73/255, alpha: 1/0)
//Sunset Orange
//let mainColor = UIColor(red: 238/255, green: 96/255, blue: 85/255, alpha: 1/0)
//Pastel Red
//let mainColor = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1/0)
//Red-Orange
//let mainColor = UIColor(red: 240/255, green: 84/255, blue: 79/255, alpha: 1/0)
// Carribean Sea
let mainColor = UIColor(red: 3/255, green: 206/255, blue: 164/255, alpha: 1/0)

class RestaurantTableViewController: UITableViewController {
    
    //MARK: - Properties
    var filteredRestaurants: [Business] = []
    let restaurantView = RestaurantView()
    var isSearchActive = false
    var restaurantLocationManager = LocationManager()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: - Private Functions
    
    @objc private func updateTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    private func setupView() {
        restaurantView.restaurantController = self
        restaurantLocationManager.delegate = self
        self.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: RestaurantController.NotificationKeys.updateTable, object: nil)
    }
}

//MARK: - Search Bar Delegate

extension RestaurantTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRestaurants = RestaurantController.shared.restaurants.filter({ (restaurant) -> Bool in
           return restaurant.name.lowercased().contains(searchText.lowercased())
        })
        
        if filteredRestaurants.count > 0 {
            isSearchActive = true
        } else {
            isSearchActive = false
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
        
        let restaurant = isSearchActive ? filteredRestaurants[indexPath.row] : RestaurantController.shared.restaurants[indexPath.row]
        
        cell.nameLabel.text = restaurant.name
        cell.mainImageView.kf.setImage(with: URL(string: restaurant.imageURL))
        cell.addressLabel.text = "\(restaurant.address), \(restaurant.city), \(restaurant.state), \(restaurant.postal)"
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
        var currentRestaurant: Business?
        let detailTableViewController = DetailTableViewController(style: .grouped)
        
        if isSearchActive {
            currentRestaurant = filteredRestaurants[indexPath.row]
        } else {
            currentRestaurant = RestaurantController.shared.restaurants[indexPath.row]
        }
        guard let restaurant = currentRestaurant else { return }
        detailTableViewController.currentBusiness = restaurant
        navigationController?.pushViewController(detailTableViewController, animated: true)
    }
}
