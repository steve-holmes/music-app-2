//
//  ListPlayerCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class ListPlayerCell: UITableViewCell {

    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    
    override func prepareForReuse() {
        songLabel.text = nil
        singerLabel.text = nil
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
