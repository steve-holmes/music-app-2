//
//  LyricCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class LyricCell: UITableViewCell {
    
    @IBOutlet weak var lyricLabel: UILabel!
    
    override func prepareForReuse() {
        lyricLabel.text = nil
    }
    
    var lyric: String = "" {
        didSet {
            lyricLabel.text = lyric
        }
    }

}
