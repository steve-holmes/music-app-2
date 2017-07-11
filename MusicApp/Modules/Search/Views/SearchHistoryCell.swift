//
//  SearchHistoryCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/12/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class SearchHistoryCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    var content: String? = nil {
        didSet {
            contentLabel.text = content
        }
    }
    
}
