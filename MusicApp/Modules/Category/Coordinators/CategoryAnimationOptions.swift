//
//  CategoryAnimationOptions.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/17/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

protocol CategoryAnimationOptions {
    
}

extension CategoryAnimationOptions {
    
    var duration: TimeInterval { return 0.35 }
    
    var springDamping: CGFloat { return 0.8 }
    var initialVelocity: CGFloat { return 0.5 }
    
}

extension CategoryAnimationOptions {
    
    func scaleRect(_ rect: CGRect, by scale: CGFloat) -> CGRect {
        let center = centerRect(rect)
        let size = scaleSize(rect.size, by: scale)
        
        return CGRect(
            origin: CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2),
            size: size
        )
    }
    
    private func centerRect(_ rect: CGRect) -> CGPoint {
        return CGPoint(
            x: rect.origin.x + rect.size.width / 2,
            y: rect.origin.y + rect.size.height / 2
        )
    }
    
    private func scaleSize(_ size: CGSize, by scale: CGFloat) -> CGSize {
        return CGSize(width: size.width * scale, height: size.height * scale)
    }
    
}
