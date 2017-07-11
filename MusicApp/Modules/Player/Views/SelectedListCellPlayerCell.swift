//
//  SelectedListCellPlayerCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Kingfisher

class SelectedListCellPlayerCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = 5
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        let clearColor = UIColor.clear.cgColor
        let whiteColor = UIColor.white.withAlphaComponent(0.1).cgColor
        gradientLayer.colors = [clearColor, whiteColor, whiteColor, clearColor]
        
        containerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func prepareForReuse() {
        avatarImageView.image = nil
        songLabel.text = nil
        singerLabel.text = nil
    }
    
    var avatar: String = "" {
        didSet {
            let url = URL(string: avatar)
            avatarImageView.kf.setImage(with: url)
        }
    }
    
    var song: String = "" {
        didSet {
            songLabel.text = song
        }
    }
    
    var singer: String = "" {
        didSet {
            singerLabel.text = singer
        }
    }

}
