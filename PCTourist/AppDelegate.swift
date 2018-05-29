//
//  AppDelegate.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/3/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit
//import LifetimeTracker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainTabController()
//        LifetimeTracker.setup(onUpdate: LifetimeTrackerDashboardIntegration(visibility: .alwaysVisible).refreshUI)
        return true
    }
    
    
}

