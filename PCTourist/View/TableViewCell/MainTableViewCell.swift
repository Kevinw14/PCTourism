//
//  MainTableViewCell.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/5/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
import SkeletonView

class MainTableViewCell: UITableViewCell {
    
    //MARK: - Initlization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properities
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.layer.opacity = 0.8
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageViewOverlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.isSkeletonable = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Layout Views
    
    override func layoutSubviews() {
        super .layoutSubviews()
        contentView.addSubview(mainImageView)
        contentView.addSubview(imageViewOverlay)
        contentView.addSubview(nameLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(distanceLabel)
        
        mainImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        mainImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        imageViewOverlay.widthAnchor.constraint(equalTo: mainImageView.widthAnchor).isActive = true
        imageViewOverlay.heightAnchor.constraint(equalTo: mainImageView.heightAnchor).isActive = true
        
        addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        
        nameLabel.bottomAnchor.constraint(equalTo: addressLabel.topAnchor, constant: -25).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: addressLabel.trailingAnchor).isActive = true
        
        distanceLabel.leadingAnchor.constraint(equalTo: addressLabel.leadingAnchor).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    }
}
