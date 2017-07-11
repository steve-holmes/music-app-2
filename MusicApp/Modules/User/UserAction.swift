//
//  UserAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

protocol UserAction {
    
    var store: UserStore { get }
    
}

class MAUserAction: UserAction {
    
    let store: UserStore
    
    init(store: UserStore) {
        self.store = store
    }
    
}
