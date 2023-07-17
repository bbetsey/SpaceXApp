//
//  AppDelegate.swift
//  SpaceXApp
//
//  Created by Anton Tropin on 11.07.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: RocketsViewController())
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

