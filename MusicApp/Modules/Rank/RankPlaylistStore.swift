//
//  RankPlaylistStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol RankPlaylistStore {
    
    var playlists: Variable<[Playlist]> { get }
    
}

class MARankPlaylistStore: RankPlaylistStore {
    
    let playlists = Variable<[Playlist]>([])
    
}
