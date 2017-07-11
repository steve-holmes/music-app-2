//
//  SearchAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/11/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action

protocol SearchAction {
    
    var store: SearchStore { get }
    
}

class MASearchAction: SearchAction {
    
    let store: SearchStore
    let service: SearchService
    
    init(store: SearchStore, service: SearchService) {
        self.store = store
        self.service = service
    }
    
}
