//
//  HomeStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol HomeStore {
    
    var info: Variable<HomeInfo?> { get }
    
}

class MAHomeStore: HomeStore {
    
    let info = Variable<HomeInfo?>(nil)
    
}
