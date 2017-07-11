//
//  MainTabBarView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import NSObject_Rx

class MainTabBarView: UIView {

    @IBOutlet weak var leftItem: MainTabItemView!
    @IBOutlet weak var rightItem: MainTabItemView!
    
    func configure(store: MainStore, action: MainAction) {
        leftItem.configure(store: store, action: action)
        rightItem.configure(store: store, action: action)
        setState(.online)
        
        bind(action: action, store: store)
    }

}

// MARK: Action

extension MainTabBarView {
    
    func bind(action: MainAction, store: MainStore) {
        Observable.from([
            leftItem.rx.tapGesture().when(.recognized).map { _ -> MainState in .user },
            rightItem.rx.tapGesture().when(.recognized).map { _ -> MainState in .online }
            ])
            .merge()
            .filter { state in state != store.position.value }
            .bind(to: action.onMenuItemTap.inputs)
            .addDisposableTo(rx_disposeBag)
    }
    
}

// MARK: State

extension MainTabBarView {
    
    func setState(_ state: MainState) {
        updateItems(at: state)
    }
    
}

// MARK: Update UI

extension MainTabBarView {
    
    func updateItems(at state: MainState) {
        switch state {
        case .user: updateUserItem()
        case .online: updateOnlineItem()
        }
    }
    
    private func updateUserItem() {
        leftItem.setState(.selected)
        rightItem.setState(.normal)
    }
    
    private func updateOnlineItem() {
        leftItem.setState(.normal)
        rightItem.setState(.selected)
    }
    
}
