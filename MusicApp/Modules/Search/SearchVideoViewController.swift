//
//  SearchVideoViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/11/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SearchVideoViewController: UIViewController {
    
    var store: SearchStore!
    var action: SearchAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindStore()
        bindAction()
    }

}

extension SearchVideoViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Video"
    }
    
}

extension SearchVideoViewController {
    
    func bindStore() {
        
    }
    
}

extension SearchVideoViewController {
    
    func bindAction() {
        
    }
    
}
