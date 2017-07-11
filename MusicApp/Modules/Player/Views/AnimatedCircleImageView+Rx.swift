//
//  AnimatedCircleImageView+Rx.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: AnimatedCircleImageView {
    
    var image: UIBindingObserver<Base, String> {
        return UIBindingObserver(UIElement: self.base) { imageView, image in
            imageView.image = image
        }
    }
    
}
