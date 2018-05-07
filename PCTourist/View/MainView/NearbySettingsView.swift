//
//  NearbySettingsView.swift
//  PCTourist
//
//  Created by Kevin Wood on 5/7/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit

class NearbySettingsView: UIView {
    
    //MARK: - Properties
    
    let radiusNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nearby Radius"
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = mainColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let settingsBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let radiusLabel: UILabel = {
        let label = UILabel()
        label.textColor = mainColor
        label.layer.cornerRadius = 25
        label.layer.borderWidth = 1.0
        label.textAlignment = .center
        label.layer.borderColor = mainColor.cgColor
        label.text = "5 miles"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let settingsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Radius").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let increaseButton: UIButton = {
        let button = UIButton()
        button.tintColor = mainColor
        button.setBackgroundImage(#imageLiteral(resourceName: "Increase").withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let decreaseButton: UIButton = {
        let button = UIButton()
        button.tintColor = mainColor
        button.setBackgroundImage(#imageLiteral(resourceName: "Decrease").withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(mainColor, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1.0
        button.layer.borderColor = mainColor.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var nearbySettingsController: NearbySettingsViewController? {
        didSet {
            increaseButton.addTarget(nearbySettingsController, action: #selector(nearbySettingsController?.increaseRadius), for: .touchUpInside)
            decreaseButton.addTarget(nearbySettingsController, action: #selector(nearbySettingsController?.decreaseRadius), for: .touchUpInside)
            cancelButton.addTarget(nearbySettingsController, action: #selector(nearbySettingsController?.cancelSettings), for: .touchUpInside)
            applyButton.addTarget(nearbySettingsController, action: #selector(nearbySettingsController?.applySettings), for: .touchUpInside)
        }
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        addSubview(settingsBackgroundView)
        settingsBackgroundView.addSubview(settingsImageView)
        addSubview(radiusNameLabel)
        addSubview(radiusLabel)
        addSubview(increaseButton)
        addSubview(decreaseButton)
        addSubview(applyButton)
        addSubview(cancelButton)
        
        settingsBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        settingsBackgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        settingsBackgroundView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        settingsBackgroundView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        settingsImageView.centerXAnchor.constraint(equalTo: settingsBackgroundView.centerXAnchor).isActive = true
        settingsImageView.topAnchor.constraint(equalTo: settingsBackgroundView.topAnchor, constant: 5).isActive = true
        
        radiusNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        radiusNameLabel.topAnchor.constraint(equalTo: settingsBackgroundView.bottomAnchor, constant: 15).isActive = true
        
        radiusLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        radiusLabel.topAnchor.constraint(equalTo: radiusNameLabel.bottomAnchor, constant: 15).isActive = true
        radiusLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        radiusLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        increaseButton.centerYAnchor.constraint(equalTo: radiusLabel.centerYAnchor).isActive = true
        increaseButton.leadingAnchor.constraint(equalTo: radiusLabel.trailingAnchor, constant: 50).isActive = true
        
        decreaseButton.centerYAnchor.constraint(equalTo: radiusLabel.centerYAnchor).isActive = true
        decreaseButton.trailingAnchor.constraint(equalTo: radiusLabel.leadingAnchor, constant: -50).isActive = true
        
        cancelButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -30).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        cancelButton.topAnchor.constraint(equalTo: radiusLabel.bottomAnchor, constant: 10).isActive = true
        
        applyButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 30).isActive = true
        applyButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor).isActive = true
        applyButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        applyButton.topAnchor.constraint(equalTo: cancelButton.topAnchor).isActive = true
    }
}
