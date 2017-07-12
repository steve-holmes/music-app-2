//
//  SearchAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/11/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action

protocol SearchAction {
    
    var store: SearchStore { get }
    
    var searchTextChange: Action<String, Void> { get }
    var searchTextClear: CocoaAction { get }
    
    var songDidSelect: Action<Song, Void> { get }
    var playlistDidSelect: Action<Playlist, Void> { get }
    var videoDidSelect: Action<Video, Void> { get }
    
    var onContextButtonTap: Action<Song, Void> { get }
    
    var searchStateChange: Action<SearchState, Void> { get }
    
}

class MASearchAction: SearchAction {
    
    let store: SearchStore
    let service: SearchService
    
    init(store: SearchStore, service: SearchService) {
        self.store = store
        self.service = service
    }
    
    lazy var searchTextChange: Action<String, Void> = {
        return Action { [weak self] query in
            guard let this = self else { return .empty() }
            
            let allSearch = this.service.search(query)
                .do(onNext: { response in
                    guard case let .item(info) = response else { return }
                    this.store.info.value = info
                })
                .map { _ in }
            
            let songSearch = this.service.searchSong(query)
                .do(onNext: { response in
                    guard case let .item(songs) = response else { return }
                    this.store.songs.value = songs
                })
                .map { _ in }
            
            let playlistSearch = this.service.searchPlaylist(query)
                .do(onNext: { response in
                    guard case let .item(playlists) = response else { return }
                    this.store.playlists.value = playlists
                })
                .map { _ in }
            
            let videoSearch = this.service.searchVideo(query)
                .do(onNext: { response in
                    guard case let .item(videos) = response else { return }
                    this.store.videos.value = videos
                })
                .map { _ in }
            
            return Observable
                .zip(allSearch, songSearch, playlistSearch, videoSearch) { _ in return }
        }
    }()
    
    lazy var searchTextClear: CocoaAction = {
        return CocoaAction { [weak self] in
            self?.store.songs.value = []
            self?.store.playlists.value = []
            self?.store.videos.value = []
            return .empty()
        }
    }()
    
    lazy var songDidSelect: Action<Song, Void> = {
        return Action { [weak self] song in
            return self?.service.play(song: song) ?? .empty()
        }
    }()
    
    lazy var playlistDidSelect: Action<Playlist, Void> = {
        return Action { [weak self] playlist in
            return self?.service.presentPlaylist(playlist) ?? .empty()
        }
    }()
    
    lazy var videoDidSelect: Action<Video, Void> = {
        return Action { [weak self] video in
            return self?.service.presentVideo(video) ?? .empty()
        }
    }()
    
    lazy var onContextButtonTap: Action<Song, Void> = {
        return Action { [weak self] song in
            return self?.service.openContextMenu(song) ?? .empty()
        }
    }()
    
    lazy var searchStateChange: Action<SearchState, Void> = {
        return Action { [weak self] state in
            self?.store.state.value = state
            return .empty()
        }
    }()
    
}
