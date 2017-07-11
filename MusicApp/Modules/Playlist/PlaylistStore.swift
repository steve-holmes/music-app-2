//
//  PlaylistStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol PlaylistStore {
    
    var playlists: Variable<[Playlist]> { get }
    var category: Variable<CategoryInfo> { get }
    
    var playlistLoading: Variable<Bool> { get }
    var loadMoreEnabled: Variable<Bool> { get }
    
    var categories: Variable<[CategoriesInfo]> { get }
    
}

class MAPlaylistStore: PlaylistStore {
    
    let playlists = Variable<[Playlist]>([])
    
    let category = Variable<CategoryInfo>(CategoryInfo(
        name: "Mới & Hot",
        new: true,
        newlink: "playlist-moi",
        hotlink: "playlist-moi-nhat"
    ))
    
    let playlistLoading = Variable<Bool>(false)
    
    let loadMoreEnabled = Variable<Bool>(true)
    
    let categories = Variable<[CategoriesInfo]>([])
    
}
