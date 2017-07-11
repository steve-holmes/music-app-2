//
//  RankVideoStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol RankVideoStore {
    
    var videos: Variable<[Video]> { get }
    
}

class MARankVideoStore: RankVideoStore {
    
    let videos = Variable<[Video]>([])
    
}
