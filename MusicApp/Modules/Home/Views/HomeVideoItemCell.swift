//
//  HomeVideoItemCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class HomeVideoItemCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 7
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
