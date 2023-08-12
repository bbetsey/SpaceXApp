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

        let rocketsViewModel = RocketsViewModel()
        let rocketsViewController = RocketsPageViewController(viewModel: rocketsViewModel)
        window?.rootViewController = UINavigationController(
            rootViewController: rocketsViewController
        )

        window?.makeKeyAndVisible()
        
        return true
    }
    
}
