//
//  PlayerPageControl.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import CHIPageControl

class PlayerPageControl: UIView {

    private let pageControl = CHIPageControlChimayo(frame: .zero)
    
    func configure() {
        pageControl.numberOfPages = 3
        pageControl.radius = 4
        pageControl.tintColor = .background
        pageControl.padding = 8
        pageControl.progress = 0.1
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: topAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    var currentPage: Int {
        get {
            return pageControl.currentPage
        }
        set {
             pageControl.set(progress: newValue, animated: true)
        }
    }

}
