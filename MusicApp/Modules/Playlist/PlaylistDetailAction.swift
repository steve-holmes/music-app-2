//
//  PlaylistDetailAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/18/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import Action

protocol PlaylistDetailAction {
    
    var store: PlaylistDetailStore { get }
    
    var onLoad: Action<Void, PlaylistDetailInfo> { get }
    
    func onPlaylistDetailStateChange() -> Action<PlaylistDetailState, Void>
    
    var onPlaylistDidSelect: Action<Playlist, Void> { get }
    var onSongDidSelect: Action<Song, Void> { get }
    
    func onPlayButtonPress() -> CocoaAction
    
    var onContextMenuOpen: Action<(Song, UIViewController), Void> { get }
    
}

class MAPlaylistDetailAction: PlaylistDetailAction {
    
    let store: PlaylistDetailStore
    let service: PlaylistDetailService
    
    init(store: PlaylistDetailStore, service: PlaylistDetailService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: Action<Void, PlaylistDetailInfo> = {
        return Action { [weak self] _ in
            guard let this = self else { return .empty() }
            return this.service.getPlaylist(this.store.info.value)
                .do(onNext: { detailInfo in
                    this.store.tracks.value = detailInfo.tracks
                    this.store.songs.value = detailInfo.songs
                    this.store.playlists.value = detailInfo.playlists
                    this.store.state.value = .song
                })
        }
    }()
    
    func onPlaylistDetailStateChange() -> Action<PlaylistDetailState, Void> {
        return Action { [weak self] state in
            self?.store.state.value = state
            return Observable.empty()
        }
    }
    
    lazy var onPlaylistDidSelect: Action<Playlist, Void> = {
        return Action { [weak self] playlist in
            guard let this = self else { return .empty() }
            
            this.store.loading.value = true
            
            return this.service.getPlaylist(playlist)
                .do(onNext: { detailInfo in
                    this.store.loading.value = false
                    
                    this.store.tracks.value = detailInfo.tracks
                    this.store.songs.value = detailInfo.songs
                    this.store.playlists.value = detailInfo.playlists
                    this.store.info.value = playlist
                    this.store.state.value = .song
                })
                .map { _ in }
        }
    }()
    
    lazy var onSongDidSelect: Action<Song, Void> = {
        return Action { [weak self] song in
            guard let this = self else { return .empty() }
            
            guard let songIndex = this.store.songs.value.index(of: song) else { return .empty() }
            let track = this.store.tracks.value[songIndex]
            
            return this.service.play(tracks: this.store.tracks.value, selectedTrack: track)
        }
    }()
    
    func onPlayButtonPress() -> CocoaAction {
        return CocoaAction { [weak self] in
            guard let this = self else { return .empty() }
            guard this.store.tracks.value.count > 0 else { return .empty() }
            return this.service.play(tracks: this.store.tracks.value, selectedTrack: this.store.tracks.value[0])
        }
    }
    
    lazy var onContextMenuOpen: Action<(Song, UIViewController), Void> = {
        return Action { [weak self] segueInfo in
            guard let this = self else { return .empty() }
            let (song, controller) = segueInfo
            return this.service.openContextMenu(song, in: controller)
        }
    }()
    
}
