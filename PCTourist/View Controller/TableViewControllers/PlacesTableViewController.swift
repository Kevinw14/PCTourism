//
//  PlacesTableViewController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/5/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import CoreLocation

private let reuseIdentifier = "PlaceCell"

class PlacesTableViewController: UITableViewController {

    
    //MARK: - Properties
    
    let placeView = PlaceView()
    var filteredPlaces: [Business] = []
    var isSearchActive = false
    var placesLocationManager = LocationManager()
    
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
        placeView.placeController = self
        placesLocationManager.delegate = self
        self.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: PlaceController.NotificationKeys.reloadTable, object: nil)
        LocationManager().startUpdatingLocation()
    }
}

//MARK: - Search Bar Delegate

extension PlacesTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredPlaces = PlaceController.shared.places.filter({ (place) -> Bool in
            return place.name.lowercased().contains(searchText.lowercased())
        })
        
        switch filteredPlaces.count {
        case 0: isSearchActive = false
        default: isSearchActive = true
        }
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchActive = false
        tableView.reloadData()
    }
}

//MARK: - Search Controller Delegate

extension PlacesTableViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        isSearchActive = false
        tableView.reloadData()
    }
}

//MARK: - LocationManager Delegate

extension PlacesTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        tableView.reloadData()
    }
}

// MARK: - Table view data source

extension PlacesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredPlaces.count : PlaceController.shared.places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        let place = isSearchActive ? filteredPlaces[indexPath.row]: PlaceController.shared.places[indexPath.row]
        
        cell.mainImageView.kf.setImage(with: URL(string: place.imageURL))
        cell.nameLabel.text = place.name
        cell.addressLabel.text = "\(place.address), \(place.city), \(place.state), \(place.postal)"
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            cell.distanceLabel.isHidden = false
            cell.distanceLabel.text = "\(placesLocationManager.findDistanceToLocationInMilesString(destinationLatitude: place.location.latitude, destinationLongitude: place.location.longitude))mi"
        default: cell.distanceLabel.isHidden = true
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailTableViewController(style: .grouped)
        let business = isSearchActive ? filteredPlaces[indexPath.row]: PlaceController.shared.places[indexPath.row]
        detailViewController.currentBusiness = business
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
