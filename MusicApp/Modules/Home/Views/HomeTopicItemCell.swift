//
//  HomeTopicItemCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class HomeTopicItemCell: UICollectionViewCell {
    
    @IBOutlet weak var topicImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 7
    }
    
    override func prepareForReuse() {
        topicImageView.image = nil
        nameLabel.text = nil
    }
    
    func configure(name: String, image: String) {
        nameLabel.text = name
        topicImageView.fadeImage(image)
    }
    
}
