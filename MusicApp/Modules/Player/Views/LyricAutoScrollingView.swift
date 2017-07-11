//
//  LyricAutoScrollingView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/26/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class LyricAutoScrollingView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mutateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
    }
    
    var mutateAction: CocoaAction? {
        didSet {
            mutateButton.rx.action = mutateAction
        }
    }
    
    var isHighlighted: Bool {
        get {
            return imageView.isHighlighted
        }
        set {
            imageView.isHighlighted = newValue
        }
    }

}

extension Reactive where Base: LyricAutoScrollingView {
    
    var isHighlighted: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: self.base) { lyricMutatingView, isHighlighted in
            lyricMutatingView.isHighlighted = isHighlighted
        }
    }
    
}
