//
//  SearchViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/11/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class SearchViewController: UIViewController {
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var store: SearchStore!
    var action: SearchAction!
    
    var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindStore()
        bindAction()
    }

}

extension SearchViewController {
    
    func bindStore() {
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])
        
        items
            .bind(to: historyTableView.rx.items(cellIdentifier: "SearchHistoryCell", cellType: SearchHistoryCell.self)) { _, content, cell in
                cell.content = content
            }
            .disposed(by: rx_disposeBag)
    }
    
}

extension SearchViewController {
    
    func bindAction() {
        
    }
    
}
