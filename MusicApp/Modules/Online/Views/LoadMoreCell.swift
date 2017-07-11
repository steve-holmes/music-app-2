//
//  LoadMoreCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/15/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoadMoreCell: UITableViewCell {

    @IBOutlet weak var indicatorView: NVActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.startAnimating()
    }
    
    var loadMoreEnabled: Bool = true {
        didSet {
            if loadMoreEnabled {
                indicatorView.startAnimating()
            } else {
                indicatorView.stopAnimating()
            }
        }
    }

}
