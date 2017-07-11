//
//  RankVideoAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action

protocol RankVideoAction {
    
    var store: RankVideoStore { get }
    
}

class MARankVideoAction: RankVideoAction {
    
    let store: RankVideoStore
    let service: RankVideoService
    
    init(store: RankVideoStore, service: RankVideoService) {
        self.store = store
        self.service = service
    }
    
}
