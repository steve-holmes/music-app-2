//
//  PlaylistItemCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/15/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Action

class PlaylistItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 7
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        nameLabel.text = ""
        singerLabel.text = ""
        playButton?.rx.action = nil
    }
    
    func configure(name: String, singer: String, image: String) {
        nameLabel.text = name
        singerLabel.text = singer
        imageView.fadeImage(image)
    }
    
    func configure(name: String, singer: String, image: String, action: CocoaAction) {
        configure(name: name, singer: singer, image: image)
        playButton.rx.action = action
    }
    
}
