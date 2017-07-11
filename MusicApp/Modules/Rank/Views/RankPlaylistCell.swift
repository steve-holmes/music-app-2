//
//  RankPlaylistCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class RankPlaylistCell: PlaylistDetailCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rankView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rankLabel.text = nil
    }
    
    var rank: Int = 0 {
        didSet {
            rankLabel.text = "\(rank)"
            
            switch rank {
            case 1: rankView.backgroundColor = kRankColorFirst
            case 2: rankView.backgroundColor = kRankColorSecond
            case 3: rankView.backgroundColor = kRankColorThird
            default: rankView.backgroundColor = kRankColorNormal
            }
        }
    }

}
