//
//  OnlineAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action

protocol OnlineAction {
    
    var store: OnlineStore { get }
    
    func searchBarClicked() -> CocoaAction
    
}

class MAOnlineAction: OnlineAction {
    
    let store: OnlineStore
    let service: OnlineService
    
    init(store: OnlineStore, service: OnlineService) {
        self.store = store
        self.service = service
    }
    
    func searchBarClicked() -> CocoaAction {
        return CocoaAction { [weak self] in
            self?.service.presentSearch() ?? .empty()
        }
    }
    
}
