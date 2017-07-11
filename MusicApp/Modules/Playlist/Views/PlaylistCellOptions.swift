//
//  PlaylistCellOptions.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/15/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

protocol PlaylistCellOptions: CellOptions { }

extension PlaylistCellOptions {
    
    var itemsPerLine: Int { return 2 }
    var itemPadding: CGFloat { return 8 }
    var itemRatio: CGFloat { return 11 / 9 }
    
}
