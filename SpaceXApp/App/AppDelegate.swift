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
//        window?.rootViewController = UINavigationController(rootViewController: RocketsPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none))

        let launchViewModel = LaunchViewModel(rocketID: "falcon9", rocketTitle: "Falcon 9")
        let launchCollectionViewController = LaunchCollectionViewController(launchViewModel: launchViewModel)
        window?.rootViewController = UINavigationController(rootViewController: launchCollectionViewController)
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
