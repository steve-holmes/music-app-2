//
//  OnlineSearchView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/6/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Action

class OnlineSearchView: UIView {

    private var searchBar: UISearchBar!
    private var button: UIButton!
    
    func configure(searchBar: UISearchBar) {
        self.searchBar = searchBar
        searchBar.isUserInteractionEnabled = false
        self.addSubview(searchBar)
        
        button = UIButton()
        button.rx.action = action
        
        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    var action: CocoaAction? {
        didSet {
            button.rx.action = action
        }
    }

}
