//
//  HomePlaylistCellOptions.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import QuartzCore

protocol HomePlaylistCellOptions: CellOptions { }

extension HomePlaylistCellOptions {
    
    var itemsPerLine: Int { return 3 }
    var itemPadding: CGFloat { return 8 }
    var itemRatio: CGFloat { return 1 }
    
}
