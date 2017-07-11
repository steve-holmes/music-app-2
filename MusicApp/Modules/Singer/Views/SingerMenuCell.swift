//
//  SingerMenuCell.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/22/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import RxSwift
import Action

class SingerMenuCell: UITableViewCell {

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
        
        menu.setSegmentItems(["Bài hát", "Album", "Video"])
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
    
    var action: Action<SingerDetailState, Void>?
    
    var state: SingerDetailState {
        get {
            if currentIndex == 0 {
                return .song
            } else if currentIndex == 1 {
                return .playlist
            } else {
                return .video
            }
        }
        set {
            var index = 0
            switch newValue {
            case .song: index = 0
            case .playlist: index = 1
            case .video: index = 2
            }
            
            if currentIndex != index { currentIndex = index }
        }
    }

}

extension SingerMenuCell: TwicketSegmentedControlDelegate {
    
    func didSelect(_ segmentIndex: Int) {
        if segmentIndex == currentIndex { return }
        
        currentIndex = segmentIndex
        
        if currentIndex == 0 {
            action?.execute(.song)
        } else if currentIndex == 1 {
            action?.execute(.playlist)
        } else {
            action?.execute(.video)
        }
    }
    
}
