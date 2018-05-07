//
//  NearbyTableViewController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/26/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import CoreLocation
import DZNEmptyDataSet
import Jelly

private let reuseIdentifier = "NearbyCell"

class NearbyTableViewController: UITableViewController, NearbySettingsDelegate {
    
    //MARK: - Properties
    
    let nearbyView = NearbyView()
    var fetchNearbyTimer: Timer?
    var nearbyLocationManager = LocationManager()
    var shouldOffset = false
    var animator: JellyAnimator?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super .viewDidLoad()
        setupView()
        nearbyView.nearbyRefreshControl.addTarget(NearbyController.shared, action: #selector(NearbyController.fetchNearbyLocations), for: .valueChanged)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        nearbyLocationManager.stopUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        nearbyLocationManager.startUpdatingLocation()
    }
    
    //MARK: - Private Functions
    
    @objc private func updateTable() {
        DispatchQueue.main.async {
            self.nearbyView.nearbyRefreshControl.beginRefreshing()
            self.tableView.reloadData()
            self.nearbyView.nearbyRefreshControl.endRefreshing()
        }
    }
    
    private func setupView() {
        view.addSubview(nearbyView)
        nearbyView.nearbyTableViewController = self
        nearbyLocationManager.delegate = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: NearbyController.NotificationKeys.updateTable, object:  nil)
    }
    
    @objc func nearbySettings() {
        let settingsViewController = NearbySettingsViewController()
        let settingsPresentation = JellySlideInPresentation(dismissCurve: .linear,
                                                         presentationCurve: .linear,
                                                         cornerRadius: 10,
                                                         backgroundStyle: .dimmed(alpha: 0.3),
                                                         jellyness: .jellier,
                                                         duration: .normal,
                                                         directionShow: .top,
                                                         directionDismiss: .top,
                                                         widthForViewController: .fullscreen,
                                                         heightForViewController: .custom(value: 300),
                                                         horizontalAlignment: .center,
                                                         verticalAlignment: .center,
                                                         marginGuards: UIEdgeInsetsMake(0, 10, 0, 10),
                                                         corners: [.allCorners])
        self.animator = JellyAnimator(presentation: settingsPresentation)
        self.animator?.prepare(viewController: settingsViewController)
        settingsViewController.delegate = self
        self.present(settingsViewController, animated: true, completion: nil)
    }
    
    func applySettings(_ nearbySettingsViewController: NearbySettingsViewController, radiusChangedTo radius: Double) {
        NearbyController.shared.radius = radius
        NearbyController.shared.fetchNearbyLocations()
    }
}

//MARK: - LocationManager Delegate

extension NearbyTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        tableView.reloadData()
    }
}

//MARK: - DZNEmptyDataSet Delegate

extension NearbyTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = NSAttributedString(string: "Whoops!")
        return title
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let description = NSAttributedString(string: "There's nothing nearby. \nPull to refresh.")
        return description
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "EmptyMapPin").withRenderingMode(.alwaysTemplate)
    }
    
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        if shouldOffset {
            return 150
        }
        return 0
    }
}

//MARK: - TableView Datasource & Delegate

extension NearbyTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if NearbyController.shared.nearbyLocations.count == 0 {
            tableView.separatorStyle = .none
        } else if NearbyController.shared.nearbyLocations.count > 0 {
            shouldOffset = true
        }
        return NearbyController.shared.nearbyLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        let nearbyLocation = NearbyController.shared.nearbyLocations[indexPath.row]
        
        cell.mainImageView.kf.setImage(with: URL(string: nearbyLocation.imageURL))
        cell.nameLabel.text = nearbyLocation.name
        cell.addressLabel.text = "\( nearbyLocation.address), \(nearbyLocation.city), \(nearbyLocation.state), \(nearbyLocation.postal)"
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            cell.distanceLabel.isHidden = false
            cell.distanceLabel.text = "\(nearbyLocationManager.findDistanceToLocationInMilesString(destinationLatitude: nearbyLocation.location.latitude, destinationLongitude: nearbyLocation.location.longitude))mi"
        default: cell.distanceLabel.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailTableViewController = DetailTableViewController(style: .grouped)
        let nearbyLocation = NearbyController.shared.nearbyLocations[indexPath.row]
        detailTableViewController.currentBusiness = nearbyLocation
        navigationController?.pushViewController(detailTableViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
}
