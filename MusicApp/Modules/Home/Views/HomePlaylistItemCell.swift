//
//  HomePlaylistItemCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class HomePlaylistItemCell: PlaylistItemCell {
    
    @IBOutlet weak var shadowView: UIView!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let shadowLayer = CAGradientLayer()
        shadowLayer.frame = shadowView.bounds
        shadowLayer.frame.size.width = self.bounds.width
        shadowLayer.colors = [UIColor.black.cgColor, UIColor.black.withAlphaComponent(0.8), UIColor.clear.cgColor]
        shadowLayer.locations = [0.0, 0.7, 1.0]
        shadowLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        shadowLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        shadowView.layer.addSublayer(shadowLayer)
    }
    
}
