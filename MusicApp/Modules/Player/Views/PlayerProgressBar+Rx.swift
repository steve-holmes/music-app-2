//
//  PlayerProgressBar+Rx.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/24/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: PlayerProgressBar {
    
    var duration: UIBindingObserver<Base, Int> {
        return UIBindingObserver(UIElement: self.base) { progressBar, duration in
            progressBar.duration = duration
        }
    }
    
    var currentTime: UIBindingObserver<Base, Int> {
        return UIBindingObserver(UIElement: self.base) { progressBar, currentTime in
            progressBar.currentTime = currentTime
        }
    }
    
}
