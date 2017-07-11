//
//  HomePageItemCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class HomePageItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: String = "" {
        didSet {
            imageView.fadeImage(image)
        }
    }
    
}
