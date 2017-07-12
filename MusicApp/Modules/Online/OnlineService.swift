//
//  OnlineService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol OnlineService {
    
    func presentSearch() -> Observable<Void>
    
}

class MAOnlineService: OnlineService {
    
    let coordinator: OnlineCoordinator
    
    init(coordinator: OnlineCoordinator) {
        self.coordinator = coordinator
    }
    
    func presentSearch() -> Observable<Void> {
        return coordinator.presentSearch()
    }
    
}
