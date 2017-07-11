//
//  TopicCellOptions.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

protocol TopicCellOptions: CellOptions { }

extension TopicCellOptions {
    
    var itemsPerLine: Int { return 1 }
    var itemPadding: CGFloat { return 10 }
    var itemRatio: CGFloat { return 1 / 2 }
    
}
