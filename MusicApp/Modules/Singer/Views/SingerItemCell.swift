//
//  SingerItemCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/21/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class SingerItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 7
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        nameLabel.text = ""
    }
    
    func configure(name: String, image: String) {
        nameLabel.text = name
        imageView.fadeImage(image)
    }
    
}
