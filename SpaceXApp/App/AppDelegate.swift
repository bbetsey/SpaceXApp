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
        window?.rootViewController = UINavigationController(
            rootViewController: LaunchCollectionViewController(
                launchViewModel: LaunchViewModel(rocketID: "falcon9"),
                rocketTitle: "Falcon 9"
            )
        )
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
