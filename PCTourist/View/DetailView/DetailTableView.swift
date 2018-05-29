//
//  DetailTableView.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/26/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import MapKit
import LifetimeTracker

class DetailTableView: UIView, LifetimeTrackable {
    static var lifetimeConfiguration = LifetimeConfiguration(maxCount: 1, groupName: "Detail Table View")
    
    //MARK: - Properties
    
    let imageViewCell = UITableViewCell()
    let twitterCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    let instagramCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    let airbnbCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    let categoryCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    let paymentCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    let wifiCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    let airConditionerCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    let mapViewCell = UITableViewCell()
    let addressCell = UITableViewCell()
    let directionCell = UITableViewCell()
    let phoneCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    let hoursCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    
    let placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let imageViewOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let placesMapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.showsScale = false
        mapView.showsCompass = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    var detailController: DetailTableViewController? {
        didSet {
            updateViews()
            setupNavigationBar()
        }
    }
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        trackLifetime()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Update Views
    
    private func updateViews() {
        guard let business = detailController?.currentBusiness else { return }
        detailController?.tableView.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0)
        imageViewCell.addSubview(placeImageView)
        imageViewCell.addSubview(imageViewOverlay)
        imageViewCell.addSubview(placeNameLabel)
        mapViewCell.addSubview(placesMapView)
        
        placeImageView.widthAnchor.constraint(equalTo: imageViewCell.widthAnchor).isActive = true
        placeImageView.heightAnchor.constraint(equalTo: imageViewCell.heightAnchor).isActive = true
        placeImageView.kf.setImage(with: URL(string: business.imageURL))
        
        imageViewOverlay.widthAnchor.constraint(equalTo: placeImageView.widthAnchor).isActive = true
        imageViewOverlay.heightAnchor.constraint(equalTo: placeImageView.heightAnchor).isActive = true
        
        placeNameLabel.leadingAnchor.constraint(equalTo: imageViewCell.leadingAnchor, constant: 10).isActive = true
        placeNameLabel.bottomAnchor.constraint(equalTo: imageViewCell.bottomAnchor, constant: -25).isActive = true
        placeNameLabel.text = business.name
        
        twitterCell.imageView?.image = #imageLiteral(resourceName: "Twitter")
        twitterCell.detailTextLabel?.textColor = .black
        twitterCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        twitterCell.detailTextLabel?.text = business.twitter?.uppercased()
        
        instagramCell.imageView?.image = #imageLiteral(resourceName: "Instagram")
        instagramCell.detailTextLabel?.textColor = .black
        instagramCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        instagramCell.detailTextLabel?.text = business.instagram?.uppercased()
        
        airbnbCell.imageView?.image = #imageLiteral(resourceName: "AirBnB")
        airbnbCell.detailTextLabel?.textColor = .black
        airbnbCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        airbnbCell.detailTextLabel?.text = business.name.uppercased()
        
        categoryCell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        categoryCell.textLabel?.text = "category".uppercased()
        categoryCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        categoryCell.detailTextLabel?.textColor = .black
        categoryCell.detailTextLabel?.text = business.category.uppercased()
        
        paymentCell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        paymentCell.textLabel?.text = "payment".uppercased()
        paymentCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        paymentCell.detailTextLabel?.textColor = .black
        paymentCell.detailTextLabel?.text = business.payment?.uppercased()
        
        wifiCell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        wifiCell.textLabel?.text = "wifi".uppercased()
        wifiCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        wifiCell.detailTextLabel?.textColor = .black
        wifiCell.detailTextLabel?.text = business.wifi?.uppercased()
        
        airConditionerCell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        airConditionerCell.textLabel?.text = "air-conditioned".uppercased()
        airConditionerCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        airConditionerCell.detailTextLabel?.textColor = .black
        airConditionerCell.detailTextLabel?.text = business.airConditioned?.uppercased()
        
        placesMapView.widthAnchor.constraint(equalTo: mapViewCell.widthAnchor).isActive = true
        placesMapView.heightAnchor.constraint(equalTo: mapViewCell.heightAnchor).isActive = true
        
        addressCell.accessoryType = .disclosureIndicator
        addressCell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        addressCell.textLabel?.text = "\(business.address), \(business.city), \(business.state), \(business.postal)"
        addressCell.textLabel?.adjustsFontSizeToFitWidth = true
        
        directionCell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        directionCell.textLabel?.text = "directions".uppercased()
        
        phoneCell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        phoneCell.textLabel?.text = "phone".uppercased()
        phoneCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        phoneCell.detailTextLabel?.textColor = .black
        phoneCell.detailTextLabel?.text = business.phoneNumber?.uppercased()
        
        hoursCell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        hoursCell.textLabel?.text = "hours".uppercased()
        hoursCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        hoursCell.detailTextLabel?.textColor = .black
        hoursCell.detailTextLabel?.text = "\(dayOfWeek().prefix(3)): \(business.hours?.hours ?? "")"
    }
    
    private func setupNavigationBar() {
        detailController?.navigationItem.title = detailController?.currentBusiness?.name
        detailController?.navigationController?.navigationBar.tintColor = mainColor
        detailController?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back").withRenderingMode(.alwaysTemplate),
                                                                                   style: .done,
                                                                                   target:  detailController,
                                                                                   action: #selector(detailController?.popController))
        
        detailController?.navigationController?.navigationBar.isTranslucent = true
        detailController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        detailController?.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
