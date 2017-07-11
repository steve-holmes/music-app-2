//
//  PlaylistMenuCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/18/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import RxSwift
import Action

class PlaylistMenuCell: UITableViewCell {

    private var menu: TwicketSegmentedControl!
    
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
        let width = contentView.bounds.width - 16
        let height: CGFloat = 30
        
        let x = contentView.bounds.midX - width / 2
        let y = contentView.bounds.midY - height / 2 - 5
        
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        menu = TwicketSegmentedControl(frame: frame)
        
        menu.setSegmentItems(["Bài hát", "Liên quan"])
        menu.font = .avenirNextFont()
        menu.defaultTextColor = .text
        menu.highlightTextColor = .white
        menu.segmentsBackgroundColor = .white
        menu.sliderBackgroundColor = .main
        menu.isSliderShadowHidden = false
        menu.move(to: currentIndex)
        
        menu.delegate = self
        
        menu.backgroundColor = .background
        contentView.backgroundColor = .background
        
        contentView.addSubview(menu)
    }
    
    // MARK: Properties
    
    var action: Action<PlaylistDetailState, Void>?
    
    var state: PlaylistDetailState {
        get {
            return currentIndex == 0 ? .song : .playlist
        }
        set {
            let index = newValue == .song ? 0 : 1
            if currentIndex != index { currentIndex = index }
        }
    }

}

extension PlaylistMenuCell: TwicketSegmentedControlDelegate {
    
    func didSelect(_ segmentIndex: Int) {
        if segmentIndex == currentIndex { return }
        
        currentIndex = segmentIndex
        let state: PlaylistDetailState = currentIndex == 0 ? .song : .playlist
        action?.inputs.onNext(state)
    }
    
}
