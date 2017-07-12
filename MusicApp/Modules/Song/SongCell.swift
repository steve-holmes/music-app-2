//
//  SongCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import Action

class SongCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var contextButton: UIButton!
    
    override func prepareForReuse() {
        nameLabel.text = nil
        singerLabel.text = nil
        contextButton.rx.action = nil
    }
    
    func configure(name: String, singer: String, contextAction: CocoaAction) {
        nameLabel.text = name
        singerLabel.text = singer
        contextButton.rx.action = contextAction
    }
    
    func configure(name: String, singer: String) {
        nameLabel.text = name
        singerLabel.text = singer
    }

}
