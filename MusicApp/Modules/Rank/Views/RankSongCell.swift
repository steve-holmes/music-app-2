//
//  RankSongCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/30/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class RankSongCell: SongCell {

    @IBOutlet weak var rankTitleLabel: UILabel!
    @IBOutlet weak var rankView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankTitleLabel.text = nil
    }
    
    var rank: Int = 0 {
        didSet {
            rankTitleLabel.text = "\(rank)"
            
            switch rank {
            case 1: rankView.backgroundColor = kRankColorFirst
            case 2: rankView.backgroundColor = kRankColorSecond
            case 3: rankView.backgroundColor = kRankColorThird
            default: rankView.backgroundColor = kRankColorNormal
            }
        }
    }

}
