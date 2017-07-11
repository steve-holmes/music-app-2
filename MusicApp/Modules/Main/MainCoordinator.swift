//
//  MainCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol MainCoordinator {
    
    @discardableResult
    func `switch`(to: MainState) -> Observable<Void>
    @discardableResult
    func presentPlayer() -> Observable<Void>
    @discardableResult
    func setPresentPlayerInteractively() -> Observable<Void>
    
}

class MAMainCoordinator: MainCoordinator {
    
    let switchCoordinator: MainSwitchCoordinator
    let modalCoordinator: MainModalCoordinator
    
    init(`switch`: MainSwitchCoordinator, modal: MainModalCoordinator) {
        switchCoordinator = `switch`
        modalCoordinator = modal
    }
    
    @discardableResult
    func `switch`(to state: MainState) -> Observable<Void> {
        switch state {
        case .user: return switchCoordinator.switch(to: .left, animated: true)
        case .online: return switchCoordinator.switch(to: .right, animated: true)
        }
    }
    
    @discardableResult
    func presentPlayer() -> Observable<Void> {
        return modalCoordinator.presentPlayer()
    }
    
    @discardableResult
    func setPresentPlayerInteractively() -> Observable<Void> {
        return modalCoordinator.setPresentPlayerInteractively()
    }
    
}
