//
//  OnlineAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

protocol OnlineAction {
    
    var store: OnlineStore { get }
    var service: OnlineService { get }
    
}

class MAOnlineAction: OnlineAction {
    
    let store: OnlineStore
    let service: OnlineService
    
    init(store: OnlineStore, service: OnlineService) {
        self.store = store
        self.service = service
    }
    
}
