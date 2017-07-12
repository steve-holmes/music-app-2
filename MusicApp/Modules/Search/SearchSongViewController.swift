//
//  SearchSongViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/11/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SearchSongViewController: UIViewController {
    
    var store: SearchStore!
    var action: SearchAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindStore()
        bindAction()
    }

}

extension SearchSongViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Bài hát"
    }
    
}

extension SearchSongViewController {
    
    func bindStore() {
        
    }
    
}

extension SearchSongViewController {
    
    func bindAction() {
        
    }
    
}
