//
//  VideoDetailHeaderView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class VideoDetailHeaderView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    
    var name: String? {
        get { return nameLabel.text }
        set { nameLabel.text = newValue }
    }
    
    var singer: String? {
        get { return singerLabel.text }
        set { singerLabel.text = newValue }
    }

}
