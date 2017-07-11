//
//  AppDelegate.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let module = ModuleContainer()
    
    var musicNotification: MusicNotification!

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3982247659947570~8380730445")
        
        NetworkActivityIndicatorManager.shared.isEnabled = true
        
        let musicModule = self.module.musicModule
        musicNotification = musicModule.container.resolve(MusicNotification.self)!
        
        window = UIWindow()
        let mainModule = module.mainModule
        let mainController = mainModule.container.resolve(MainViewController.self)!
        window?.rootViewController = mainController
        window?.makeKeyAndVisible()
        
        return true
    }

}

