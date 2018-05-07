//
//  SocialWebView.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/24/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit

class SocialWebView: UIView {
    
    //MARK: - Properties
    
    let socialWebView: UIWebView = {
        let webview = UIWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    //MARK: - Initilization
    
    override init(frame: CGRect) {
        super .init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        addSubview(socialWebView)
        
        socialWebView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        socialWebView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        socialWebView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
