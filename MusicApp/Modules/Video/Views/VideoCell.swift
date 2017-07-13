//
//  VideoCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/15/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    private var shadowLayer: CAGradientLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 7
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        let shadowLayer = CAGradientLayer()
        shadowLayer.frame = shadowView.layer.bounds
        shadowLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        shadowLayer.locations = [0.0, 1.0]
        shadowLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        shadowLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        
        shadowView.layer.addSublayer(shadowLayer)
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        singerLabel.text = ""
        timeLabel.text = ""
        avatarImageView.image = nil
    }
    
    func configure(name: String, singer: String, image: String, time: String) {
        nameLabel.text = name
        singerLabel.text = singer
        timeLabel.text = time
        avatarImageView.fadeImage(image)
    }

}
