//
//  PlaylistRepository.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol PlaylistRepository {
    
    func getPlaylists(on category: String) -> Observable<ItemResponse<PlaylistInfo>>
    func resetPlaylists(on category: String) -> Observable<ItemResponse<PlaylistInfo>>
    func getNextPlaylists(on category: String) -> Observable<ItemResponse<PlaylistInfo>>
    
    func getPlaylist(_ playlist: Playlist) -> Observable<(tracks: [Track], playlists: [Playlist])>
    
}

class MAPlaylistRepository: PlaylistRepository {
    
    let loader: PlaylistLoader
    let cache: CategoryCache<PlaylistInfo>
    var page = 1
    
    init(loader: PlaylistLoader, cache: CategoryCache<PlaylistInfo>) {
        self.loader = loader
        self.cache = cache
    }
    
    func getPlaylists(on category: String) -> Observable<ItemResponse<PlaylistInfo>> {
        page = 1
        return getPlaylists(on: category, at: page)
    }
    
    func resetPlaylists(on category: String) -> Observable<ItemResponse<PlaylistInfo>> {
        cache.removeItems(category: category)
        
        page = 1
        return getPlaylists(on: category, at: page)
    }
    
    func getNextPlaylists(on category: String) -> Observable<ItemResponse<PlaylistInfo>> {
        page += 1
        return getPlaylists(on: category, at: page)
    }
    
    func getPlaylists(on category: String, at page: Int) -> Observable<ItemResponse<PlaylistInfo>> {
        if let playlistInfo = cache.getItem(category: category, page: page) {
            return .just(.item(playlistInfo))
        }
        
        return loader.getPlaylists(onCategory: category, at: page)
            .do(onNext: { [weak self] info in
                guard case let .item(playlistInfo) = info else { return }
                self?.cache.setItem(playlistInfo, category: category, page: page)
            })
    }
    
    func getPlaylist(_ playlist: Playlist) -> Observable<(tracks: [Track], playlists: [Playlist])> {
        return loader.getPlaylist(playlist)
    }
    
}
