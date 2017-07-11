//
//  PlaylistDetailStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/18/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol PlaylistDetailStore {
    
    var info: Variable<Playlist> { get }
    var state: Variable<PlaylistDetailState> { get }
    var loading: Variable<Bool> { get }
    
    var tracks: Variable<[Track]> { get }
    var songs: Variable<[Song]> { get }
    var playlists: Variable<[Playlist]> { get }
    
}

class MAPlaylistDetailStore: PlaylistDetailStore {
    
    let info = Variable<Playlist>(Playlist(id: "", name: "", singer: "", avatar: ""))
    let state = Variable<PlaylistDetailState>(.song)
    let loading = Variable<Bool>(false)
    
    let tracks = Variable<[Track]>([])
    let songs = Variable<[Song]>([])
    let playlists = Variable<[Playlist]>([])
}
