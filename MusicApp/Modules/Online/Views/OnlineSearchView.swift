//
//  OnlineSearchView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/6/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class OnlineSearchView: UIView {

    private var searchBar: UISearchBar!
    
    func configure(searchBar: UISearchBar) {
        self.searchBar = searchBar
        searchBar.backgroundImage = UIImage()
        self.addSubview(searchBar)
    }

}
