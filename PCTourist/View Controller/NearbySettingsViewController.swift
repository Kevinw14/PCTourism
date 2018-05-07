//
//  NearbySettingsViewController.swift
//  PCTourist
//
//  Created by Kevin Wood on 5/7/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import Jelly

protocol NearbySettingsDelegate: class {
    func applySettings(_ nearbySettingsViewController: NearbySettingsViewController, radiusChangedTo radius: Double)
}

class NearbySettingsViewController: UIViewController {
    
    //MARK: - Properties
    var nearbySettingsView: NearbySettingsView!
    weak var delegate: NearbySettingsDelegate?
    var radius = 5.0
    
    override func viewDidLoad() {
        super .viewDidLoad()
        nearbySettingsView = NearbySettingsView(frame: UIScreen.main.bounds)
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
        if radius == 1.0 {
            nearbySettingsView.radiusLabel.text = "1 mile"
        } else {
            nearbySettingsView.radiusLabel.text = "\(Int(radius)) miles"
        }
    }
}
