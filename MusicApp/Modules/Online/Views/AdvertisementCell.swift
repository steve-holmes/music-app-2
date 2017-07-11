//
//  AdvertisementCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/15/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdvertisementCell: UITableViewCell {

    @IBOutlet weak var bannerView: GADBannerView!
    
    func configure(rootViewController controller: UIViewController) {
        bannerView.adUnitID = "ca-app-pub-3982247659947570/9857463647"
        bannerView.rootViewController = controller
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.load(request)
    }
    
}
