//
//  SearchStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/11/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SearchStore {
    
    var histories: Variable<[String]> { get }
    
    var songs: Variable<[Song]> { get }
    var playlists: Variable<[Playlist]> { get }
    var videos: Variable<[Video]> { get }
    
    var state: Variable<SearchState> { get }
    
}

class MASearchStore: SearchStore {
    
    let histories = Variable<[String]>([])
    
    let songs = Variable<[Song]>([])
    let playlists = Variable<[Playlist]>([])
    let videos = Variable<[Video]>([])
    
    let state = Variable<SearchState>(.all)
    
}
