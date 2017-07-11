//
//  OnlinePrefreshControl.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/16/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RxSwift
import RxCocoa
import NSObject_Rx

class OnlineRefreshControl: UIRefreshControl {
    
    private var indicatorView: NVActivityIndicatorView!
    
    override init() {
        super.init()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        tintColor = .clear
        backgroundColor = .clear
        
        let refreshContents = Bundle.main.loadNibNamed("OnlineRefreshControl", owner: self, options: nil)!
        let containerView = refreshContents[0] as! UIView
        indicatorView = containerView.subviews.first as! NVActivityIndicatorView
        
        containerView.frame = bounds
        self.addSubview(containerView)
        
        self.rx.controlEvent(.valueChanged)
            .map { [weak self] _ in self?.isRefreshing ?? false }
            .subscribe(onNext: { [weak self] refreshing in
                if refreshing { self?.beginRefreshing() }
                else { self?.endRefreshing() }
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    override func beginRefreshing() {
        super.beginRefreshing()
        indicatorView.startAnimating()
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        indicatorView.stopAnimating()
    }
}
