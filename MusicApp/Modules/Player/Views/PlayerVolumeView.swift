//
//  PlayerVolumeView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/26/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import MediaPlayer
import RxSwift
import Action

class PlayerVolumeView: UIView {
    
    @IBOutlet weak var muteVolumeImageView: UIImageView!
    @IBOutlet weak var volumeImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var volumeView: UIView!
    
    
    private let volumeSlider: UISlider = {
        let volumeView = MPVolumeView()
        volumeView.volumeSlider.setThumbImage(#imageLiteral(resourceName: "player_volume_thumb"), for: .normal)
        return volumeView.volumeSlider
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeView.addSubview(volumeSlider)
        
        NSLayoutConstraint.activate([
            volumeSlider.centerYAnchor.constraint(equalTo: volumeView.centerYAnchor),
            volumeSlider.leadingAnchor.constraint(equalTo: muteVolumeImageView.trailingAnchor, constant: 8),
            volumeSlider.trailingAnchor.constraint(equalTo: volumeImageView.leadingAnchor, constant: -8)
        ])
    }
    
    var action: CocoaAction? {
        get {
            return closeButton.rx.action
        }
        set {
            closeButton.rx.action = newValue
        }
    }

}

fileprivate extension MPVolumeView {
    
    var volumeSlider: UISlider {
        self.showsRouteButton = false
        self.showsVolumeSlider = false
        self.isHidden = true
        var slider = UISlider()
        for subview in self.subviews {
            if subview is UISlider {
                slider = subview as! UISlider
                slider.isContinuous = false
                (subview as! UISlider).value = AVAudioSession.sharedInstance().outputVolume
                return slider
            }
        }
        return slider
    }
    
}
