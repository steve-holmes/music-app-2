//
//  MainCoordinator+Modal+Options.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 5/27/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

protocol PlayerAnimationOptions {
    
}

extension PlayerAnimationOptions {
    
    var duration: TimeInterval { return 0.35 }
    
    var startAlpha: CGFloat { return 0.2 }
    var endAlpha: CGFloat { return 1 }
    
    var bottomDistance: CGFloat { return 10 }
    
}
