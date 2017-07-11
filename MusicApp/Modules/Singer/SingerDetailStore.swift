//
//  SingerDetailStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/21/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SingerDetailStore {
    
    var info: Variable<Singer> { get }
    var state: Variable<SingerDetailState> { get }
    
    var songs: Variable<[Song]> { get }
    var playlists: Variable<[Playlist]> { get }
    var videos: Variable<[Video]> { get }
    
    
}

class MASingerDetailStore: SingerDetailStore {
    
    let info = Variable<Singer>(Singer(id: "", name: "", avatar: ""))
    let state = Variable<SingerDetailState>(.song)
    
    let songs = Variable<[Song]>([])
    let playlists = Variable<[Playlist]>([])
    let videos = Variable<[Video]>([])
    
}
