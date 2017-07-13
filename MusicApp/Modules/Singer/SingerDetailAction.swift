//
//  SingerDetailAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/21/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action

protocol SingerDetailAction {
    
    var store: SingerDetailStore { get }
    
    var onLoad: Action<Void, SingerDetailInfo> { get }
    
    func onSingerDetailStateChange() -> Action<SingerDetailState, Void>
    
    var onSongDidSelect: Action<Song, Void> { get }
    var onPlaylistDidSelect: Action<(Playlist, UIViewController), Void> { get }
    var onVideoDidSelect: Action<(Video, UIViewController), Void> { get }
    
    var onContextMenuOpen: Action<(Song, UIViewController), Void> { get }
    
}

class MASingerDetailAction: SingerDetailAction {
    
    let store: SingerDetailStore
    let service: SingerDetailService
    
    init(store: SingerDetailStore, service: SingerDetailService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: Action<Void, SingerDetailInfo> = {
        return Action { [weak self] _ in
            guard let this = self else { return .empty() }
            return this.service.getSinger(this.store.info.value)
                .do(onNext: { detailInfo in
                    this.store.songs.value = detailInfo.songs
                    this.store.playlists.value = detailInfo.playlists
                    this.store.videos.value = detailInfo.videos
                    this.store.state.value = .song
                })
        }
    }()
    
    func onSingerDetailStateChange() -> Action<SingerDetailState, Void> {
        return Action { [weak self] state in
            self?.store.state.value = state
            return Observable.empty()
        }
    }
    
    lazy var onSongDidSelect: Action<Song, Void> = {
        return Action { [weak self] song in
            self?.service.play(song) ?? .empty()
        }
    }()
    
    lazy var onPlaylistDidSelect: Action<(Playlist, UIViewController), Void> = {
        return Action { [weak self] segueInfo in
            let (playlist, controller) = segueInfo
            return self?.service.presentPlaylist(playlist, in: controller) ?? .empty()
        }
    }()
    
    lazy var onVideoDidSelect: Action<(Video, UIViewController), Void> = {
        return Action { [weak self] info in
            let (video, controller) = info
            return self?.service.presentVideo(video, in: controller) ?? .empty()
        }
    }()
    
    lazy var onContextMenuOpen: Action<(Song, UIViewController), Void> = {
        return Action { [weak self] segueInfo in
            let (song, controller) = segueInfo
            return self?.service.openContextMenu(song, in: controller) ?? .empty()
        }
    }()
    
}
