//
//  VideoItemCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/22/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class VideoItemCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        singerLabel.text = nil
        avatarImageView.image = nil
    }
    
    func configure(name: String, singer: String, image: String) {
        nameLabel.text = name
        singerLabel.text = singer
        avatarImageView.fadeImage(image)
    }

}
