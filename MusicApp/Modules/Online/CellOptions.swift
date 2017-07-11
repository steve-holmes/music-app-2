//
//  CellOptions.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/21/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

protocol CellOptions {

    var itemsPerLine: Int { get }
    var itemPadding: CGFloat { get }
    var itemRatio: CGFloat { get }
    
    func size(of view: UIView) -> CGSize
    func width(of view: UIView) -> CGFloat
    func height(of view: UIView) -> CGFloat

}

extension CellOptions {
    
    func size(of view: UIView) -> CGSize {
        let width = self.width(of: view)
        let height = width * itemRatio
        return CGSize(width: width, height: height)
    }
    
    func width(of view: UIView) -> CGFloat {
        return (view.bounds.size.width - CGFloat(itemsPerLine + 1) * itemPadding) / CGFloat(itemsPerLine)
    }
    
    func height(of view: UIView) -> CGFloat {
        let width = self.width(of: view)
        return width * itemRatio
    }
    
}
