//
//  HomeTopicCellOptions.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import QuartzCore

protocol HomeTopicCellOptions: CellOptions { }

extension HomeTopicCellOptions {
    
    var itemsPerLine: Int { return 2 }
    var itemPadding: CGFloat { return 8 }
    var itemRatio: CGFloat { return 1.0 / 2.0 }
    
}
