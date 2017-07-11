//
//  VideoOptions.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/15/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

protocol VideoCellOptions {
    
}

extension VideoCellOptions {
    
    var itemPadding: CGFloat { return 10 }
    var itemRatio: CGFloat { return 4 / 7 }
    
    func size(of view: UIView) -> CGSize {
        let width = self.width(of: view)
        let height = width * itemRatio
        return CGSize(width: width, height: height)
    }
    
    func width(of view: UIView) -> CGFloat {
        return view.bounds.size.width - 2 * itemPadding
    }
    
    func height(of view: UIView) -> CGFloat {
        let width = self.width(of: view)
        return width * itemRatio
    }
    
}
