//
//  SearchGeneralViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/11/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class SearchGeneralViewController: UIViewController {
    
    var store: SearchStore!
    var action: SearchAction!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindStore()
        bindAction()
    }

}

extension SearchGeneralViewController: IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Tất cả"
    }
    
}

extension SearchGeneralViewController {
    
    func bindStore() {
        
    }
    
}

extension SearchGeneralViewController {
    
    func bindAction() {
        
    }
    
}
