//
//  HomeVideoCellOptions.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import QuartzCore

protocol HomeVideoCellOptions: CellOptions { }

extension HomeVideoCellOptions {
    
    var itemsPerLine: Int { return 2 }
    var itemPadding: CGFloat { return 8 }
    var itemRatio: CGFloat { return 0.75 }
    
}
