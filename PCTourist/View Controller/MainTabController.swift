//
//  MainTabController.swift
//  PCTourist
//
//  Created by Kevin Wood on 4/3/18.
//  Copyright © 2018 Kevin Wood. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: mainColor], for: .normal)
        UITabBar.appearance().tintColor = mainColor
        
        let nearbyViewController = NearbyTableViewController()
        nearbyViewController.tabBarItem = UITabBarItem(title: "Nearby", image: #imageLiteral(resourceName: "Nearby"), selectedImage: #imageLiteral(resourceName: "Nearby-Filled"))
        let navigationNearbyViewController = UINavigationController(rootViewController: nearbyViewController)
        
        let restaurantViewController = RestaurantTableViewController()
        restaurantViewController.tabBarItem = UITabBarItem(title: "Eat", image: #imageLiteral(resourceName: "Restaurant"), selectedImage: #imageLiteral(resourceName: "Restaurant-Filled"))
        let navigationRestaurantController = UINavigationController(rootViewController: restaurantViewController)
        
        let attractionsViewController = AttractionTableViewController()
        attractionsViewController.tabBarItem = UITabBarItem(title: "Do", image: #imageLiteral(resourceName: "Attraction"), selectedImage: #imageLiteral(resourceName: "Attraction-Filled"))
        let navigationAttractionsViewController = UINavigationController(rootViewController: attractionsViewController)
        
        let housingViewController = PlacesTableViewController()
        housingViewController.tabBarItem = UITabBarItem(title: "Stay", image: #imageLiteral(resourceName: "Bed"), selectedImage: #imageLiteral(resourceName: "Bed-Filled"))
        let navigationHousingViewController = UINavigationController(rootViewController: housingViewController)
        
        viewControllers = [navigationNearbyViewController, navigationRestaurantController, navigationAttractionsViewController, navigationHousingViewController]
    }
}
