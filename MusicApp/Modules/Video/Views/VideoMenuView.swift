//
//  VideoMenuView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import RxSwift
import Action

class VideoMenuView: UIView {

    @IBOutlet weak var menu: TwicketSegmentedControl!
    
    fileprivate var currentIndex = 0 {
        didSet {
            if currentIndex == oldValue { return }
            menu.move(to: currentIndex)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        menu.setSegmentItems(["Liên quan", "Cùng ca sĩ"])
        menu.font = .avenirNextFont()
        menu.defaultTextColor = .text
        menu.highlightTextColor = .white
        menu.segmentsBackgroundColor = .white
        menu.sliderBackgroundColor = .main
        menu.isSliderShadowHidden = false
        menu.move(to: currentIndex)
        
        menu.delegate = self
        
        menu.backgroundColor = .background
        backgroundColor = .background
    }
    
    // MARK: Properties
    
    var action: Action<VideoDetailState, Void>?
    
    var state: VideoDetailState {
        get {
            return currentIndex == 0 ? .other : .singer
        }
        set {
            let index = newValue == .other ? 0 : 1
            if currentIndex != index { currentIndex = index }
        }
    }

}

extension VideoMenuView: TwicketSegmentedControlDelegate {
    
    func didSelect(_ segmentIndex: Int) {
        if segmentIndex == currentIndex { return }
        
        currentIndex = segmentIndex
        let state: VideoDetailState = currentIndex == 0 ? .other : .singer
        action?.execute(state)
    }
    
}
