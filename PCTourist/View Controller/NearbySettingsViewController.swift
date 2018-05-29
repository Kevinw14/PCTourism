//
//  NearbySettingsViewController.swift
//  PCTourist
//
//  Created by Kevin Wood on 5/7/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import Jelly
import LifetimeTracker

protocol NearbySettingsDelegate: class {
    func applySettings(_ nearbySettingsViewController: NearbySettingsViewController, radiusChangedTo radius: Double)
}

class NearbySettingsViewController: UIViewController, LifetimeTrackable {
    
    static var lifetimeConfiguration = LifetimeConfiguration(maxCount: 1, groupName: "Nearby Settings View Controller")
    
    
    //MARK: - Properties
    
    var nearbySettingsView: NearbySettingsView!
    weak var delegate: NearbySettingsDelegate?
    var radius = 5.0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super .viewDidLoad()
        trackLifetime()
        nearbySettingsView = NearbySettingsView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: 300))
        view.addSubview(nearbySettingsView)
        nearbySettingsView.nearbySettingsController = self
        if UserDefaults().double(forKey: "radius") != 0.0 {
            radius = UserDefaults().double(forKey: "radius")
        }
        
        setupViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super .viewDidDisappear(animated)
        nearbySettingsView = nil
        
    }
    
    //MARK: - Actions
    
    @objc func increaseRadius() {
        if radius >= 1 && radius < 50 {
            radius += 5
            setupViews()
        }
    }
    
    @objc func decreaseRadius() {
        if radius <= 50 && radius > 5 {
            radius -= 5
            setupViews()
        }
    }
    
    @objc func cancelSettings() {
       dismiss(animated: true, completion: nil)
    }
    
    @objc func applySettings() {
        delegate?.applySettings(self, radiusChangedTo: radius)
        UserDefaults().set(radius, forKey: "radius")
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private Functions
    
    private func setupViews() {
        nearbySettingsView.radiusLabel.text = "\(Int(radius)) miles"
        
        switch radius {
        case 5.0: nearbySettingsView.decreaseButton.isEnabled = false
        case 50.0: nearbySettingsView.increaseButton.isEnabled = false
        default: nearbySettingsView.increaseButton.isEnabled = true
        nearbySettingsView.decreaseButton.isEnabled = true
        }
    }
}
