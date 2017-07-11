//
//  RankSongStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/30/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol RankSongStore {
    
    var tracks: Variable<[Track]> { get }
    
}

class MARankSongStore: RankSongStore {
    
    let tracks = Variable<[Track]>([])
    
}
