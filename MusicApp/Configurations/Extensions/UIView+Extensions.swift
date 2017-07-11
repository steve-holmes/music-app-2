//
//  UIView+OnLoad.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 5/26/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

// MARK: On Load

extension UIView {
    
    func onLoad() { }
    
}

// MARK: Remove Subviews

extension UIView {
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
}

// MARK: Frame

extension UIView {
    func frameEqual(with view: UIView) {
        self.frame = view.bounds
    }
    
    func frameEqual(with view: UIView, originX: CGFloat) {
        var frame = view.bounds
        frame.origin.x = originX
        self.frame = frame
    }
}
