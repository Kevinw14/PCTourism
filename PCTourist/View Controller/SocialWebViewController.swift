//
//  SocialWebViewController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/24/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit

class SocialWebViewController: UIViewController {
    
    //MARK: - Properties
    
    var socialWebView = SocialWebView(frame: UIScreen.main.bounds)
    var urlRequest: URLRequest?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super .viewDidLoad()
        guard let request = urlRequest else { return }
        view.addSubview(socialWebView)
        socialWebView.socialWebView.loadRequest(request)
    }
}
