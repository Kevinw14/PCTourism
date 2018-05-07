//
//  AttractionTableViewController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/3/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import CoreLocation

private let reuseIdentifier = "AttractionCell"

class AttractionTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    let attractionView = AttractionView()
    var isSearchActive = false
    var filteredAttractions: [Business] = []
    var attractionLocationManager = LocationManager()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super .viewDidLoad()
        setupView()
    }
    
    //MARK: - Private Functions
    
    @objc private func updateTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupView() {
        attractionView.attractionController = self
        attractionLocationManager.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: AttractionController.NotificationKeys.updateTable, object: nil)
        self.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        LocationManager().startUpdatingLocation()
    }
}

//MARK: - Search Bar Delegate

extension AttractionTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredAttractions = AttractionController.shared.attractions.filter({ (attraction) -> Bool in
            return attraction.name.lowercased().contains(searchText.lowercased())
        })
        
        switch filteredAttractions.count {
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

extension AttractionTableViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        isSearchActive = false
        tableView.reloadData()
    }
}

//MARK: - Location Manager Delegate

extension AttractionTableViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        tableView.reloadData()
    }
}

// MARK: - Table view data source

extension AttractionTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredAttractions.count : AttractionController.shared.attractions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        let attraction = isSearchActive ? filteredAttractions[indexPath.row] : AttractionController.shared.attractions[indexPath.row]
        
        cell.nameLabel.text = attraction.name
        cell.mainImageView.kf.setImage(with: URL(string: attraction.imageURL))
        cell.addressLabel.text = "\(attraction.address), \(attraction.city), \(attraction.state), \(attraction.postal)"
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            cell.distanceLabel.isHidden = false
            cell.distanceLabel.text = "\(attractionLocationManager.findDistanceToLocationInMilesString(destinationLatitude: attraction.location.latitude, destinationLongitude: attraction.location.longitude))mi"
        default: cell.distanceLabel.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailTableViewController(style: .grouped)
        let business = isSearchActive ? filteredAttractions[indexPath.row] : AttractionController.shared.attractions[indexPath.row]
        detailViewController.currentBusiness = business
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
