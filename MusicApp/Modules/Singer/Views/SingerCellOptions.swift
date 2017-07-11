//
//  SingerCellOptions.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/21/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

protocol SingerCellOptions: CellOptions { }

extension SingerCellOptions {
    
    var itemsPerLine: Int { return 3 }
    var itemPadding: CGFloat { return 8 }
    var itemRatio: CGFloat { return 7 / 5 }
    
}
