//
//  DetailTableViewController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/24/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import MapKit

class DetailTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    var currentBusiness: Business?
    var detailTableView: DetailTableView!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super .viewDidLoad()
        detailTableView = DetailTableView()
        detailTableView.detailController = self
        showLocationOnMapView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        detailTableView = nil
    }
    
    //MARK: - Table View Datasource & Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {

        case 0: switch indexPath.row {

        case 0: return detailTableView.imageViewCell

        case 1: if currentBusiness?.twitter != nil {
            return detailTableView.twitterCell
            }

        case 2: if currentBusiness?.instagram != nil {
            return detailTableView.instagramCell
            }

        case 3: if currentBusiness?.airbnb != nil {
            return detailTableView.airbnbCell
            }
        case 4: return detailTableView.categoryCell

        case 5: if currentBusiness?.payment != nil {
            return detailTableView.paymentCell
            }

        case 6: if currentBusiness?.wifi != nil {
            return detailTableView.wifiCell
            }

        case 7: if currentBusiness?.airConditioned != nil {
            return detailTableView.airConditionerCell
            }

        case 8: return detailTableView.mapViewCell

        case 9: return detailTableView.addressCell

        case 10: return detailTableView.directionCell

        case 11: if currentBusiness?.phoneNumber != nil {
            return detailTableView.phoneCell
            }

        case 12: if currentBusiness?.hours?.todaysHours != nil {
            return detailTableView.hoursCell
            }

        default: return UITableViewCell()
            }
        default: return UITableViewCell()
        }

        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0: switch indexPath.row {
            //ImageView
        case 0: return false
            //Twitter
        case 1: return true
            //Instagram
        case 2: return true
            //AirBnB
        case 3: return true
            //Category
        case 4: return false
            //Payment
        case 5: return false
            //Wifi
        case 6: return false
            //AirConditioned
        case 7: return false
            //MapView
        case 8: return false
            //Address
        case 9: return true
            //Directions
        case 10: return true
            //Phone Number
        case 11: return true
            //Business Hours
        case 12: return false
        default: return false
            }
        default: return false
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {

        case 0: switch indexPath.row {
        case 1: openTwitter()
        case 2: openInstagram()
        case 3: openAirBNB()
        case 9: segueToMapView()
        case 10: openMaps()
        case 11: openPhone()
        default: break
            }
        default: break
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: switch indexPath.row {
            //ImageView
        case 0: return 235
            //Twitter
        case 1: if currentBusiness?.twitter == nil {
            return 0
            }
            //Instagram
        case 2: if currentBusiness?.instagram == nil {
            return 0
            }
            //AirBnB
        case 3: if currentBusiness?.airbnb == nil {
            return 0
            }
            //Category
        case 4: return 50
            //Payment
        case 5: if currentBusiness?.payment == nil {
            return 0
            }
            //Wifi
        case 6: if currentBusiness?.wifi == nil {
            return 0
            }
            //AirConditioned
        case 7: if currentBusiness?.airConditioned == nil {
            return 0
            }
            //MapView
        case 8: return 150
            //Address
        case 9: return 50
            //Directions
        case 10: return 50
            //Phone Number
        case 11: if currentBusiness?.phoneNumber == nil {
            return 0
            }
            //Business Hours
        case 12: if currentBusiness?.hours?.todaysHours == nil {
            return 0
            }
        default: return 50
            }
        default: return 50
        }
        return 50
    }
    
    //MARK: - Private Functions
    
    @objc func popController() {
        navigationController?.popViewController(animated: true)
    }
    
    private func openTwitter() {
        let twitterHook = "twitter://user?screen_name=\(currentBusiness?.twitter ?? "")"
        guard let twitterHookURL = URL(string: twitterHook) else { return }
        if UIApplication.shared.canOpenURL(twitterHookURL) {
            UIApplication.shared.open(twitterHookURL, options: [:], completionHandler: nil)
        } else {
            let socialWebViewController = SocialWebViewController()
            guard let url = URL(string: "https://twitter.com/\(currentBusiness?.twitter ?? "")") else { return }
            let urlRequest = URLRequest(url: url)
            socialWebViewController.urlRequest = urlRequest
            navigationController?.pushViewController(socialWebViewController, animated: true)
        }
    }
    
    private func openInstagram() {
        let instagramHook = "instagram://user?username=\(currentBusiness?.instagram ?? "")"
        guard let instagramHookURL = URL(string: instagramHook) else { return }
        if UIApplication.shared.canOpenURL(instagramHookURL) {
            UIApplication.shared.open(instagramHookURL, options: [:], completionHandler: nil)
        } else {
            let socialWebViewController = SocialWebViewController()
            guard let url = URL(string: "https://www.instagram.com/\(currentBusiness?.instagram ?? "")") else { return }
            let urlRequest = URLRequest(url: url)
            socialWebViewController.urlRequest = urlRequest
            navigationController?.pushViewController(socialWebViewController, animated: true)
        }
    }
    
    private func openAirBNB() {
        let airBNBHook = "airbnb://rooms/\(currentBusiness?.airbnb ?? "")"
        guard let airBNBHookURL = URL(string: airBNBHook) else { return }
        if UIApplication.shared.canOpenURL(airBNBHookURL) {
            UIApplication.shared.open(airBNBHookURL, options: [:], completionHandler: nil)
        } else {
            let socialWebViewController = SocialWebViewController()
            guard let url = URL(string: "https://www.airbnb.com/rooms/\(currentBusiness?.airbnb ?? "")") else { return }
            let urlRequest = URLRequest(url: url)
            socialWebViewController.urlRequest = urlRequest
            navigationController?.pushViewController(socialWebViewController, animated: true)
        }
    }
    
    private func segueToMapView() {
        let detailMapViewController = DetailMapViewController()
        detailMapViewController.currentBusiness = currentBusiness
        navigationController?.pushViewController(detailMapViewController, animated: true)
    }
    
    private func openPhone() {
        guard let number = currentBusiness?.phoneNumber else { return }
        
        let alertController = UIAlertController(title: number, message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let callAction = UIAlertAction(title: "Call", style: .default) { (_) in
            guard let rawPhoneNumber = URL(string:"tel://\(number.components(separatedBy: .punctuationCharacters).joined())") else { return }
            UIApplication.shared.open(rawPhoneNumber, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(callAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func openMaps() {
        guard let latitiude = currentBusiness?.location.latitude, let longitude = currentBusiness?.location.longitude else { return }
        let coordinates = CLLocationCoordinate2DMake(latitiude, longitude)
        let placeMark = MKPlacemark(coordinate: coordinates)
        let mkMapItem = MKMapItem(placemark: placeMark)
        mkMapItem.name = currentBusiness?.name
        mkMapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeDriving:MKLaunchOptionsDirectionsModeKey])
    }
    
    private func showLocationOnMapView() {
        guard let latitude = currentBusiness?.location.latitude, let longitude = currentBusiness?.location.longitude else { return }

        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let annotation = MKPointAnnotation()
        annotation.title = currentBusiness?.name
        annotation.coordinate = coordinates
        detailTableView.placesMapView.addAnnotation(annotation)

        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegionMake(coordinates, span)
        detailTableView.placesMapView.setRegion(region, animated: true)
    }
}
