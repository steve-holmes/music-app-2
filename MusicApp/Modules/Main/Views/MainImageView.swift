//
//  MainImageView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/10/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import NSObject_Rx

class MainImageView: UIView {
    
    @IBOutlet weak var animatedImageView: AnimatedCircleImageView!
    @IBOutlet weak var iconView: UIImageView!
    
    func configure(store: MainStore, action: MainAction, center: CGPoint) {
        layer.cornerRadius = bounds.size.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.main.cgColor
        
        iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = .white
        
        self.center = center
        
        bind(action)
    }
    
    var backgroundImage: String? = nil { didSet { animatedImageView.image = backgroundImage ?? "" } }
    
    var visible: Bool = true { didSet { iconView.isHidden = !visible } }
    
    func startRotating() {
        animatedImageView.startAnimating()
    }
    
    func stopRotating() {
        animatedImageView.stopAnimating()
    }

}

extension MainImageView {
    
    func bind(_ action: MainAction) {
        self.rx.tapGesture().when(.recognized)
            .map { _ in }
            .subscribe(action.onImageTap.inputs)
            .addDisposableTo(rx_disposeBag)
    }
    
}
