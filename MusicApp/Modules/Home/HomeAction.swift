//
//  HomeAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action

protocol HomeAction {
    
    var store: HomeStore { get }
    
    var onLoad: CocoaAction { get }
    
    func onPageDidSelect() -> Action<Playlist, Void>
    func onPlaylistDidSelect() -> Action<Playlist, Void>
    func onVideoDidSelect() -> Action<Video, Void>
    func onFilmDidSelect() -> Action<Video, Void>
    func onTopicDidSelect() -> Action<Topic, Void>
    func onSongDidSelect() -> Action<Song, Void>
    
    func onContextButtonTap() -> Action<Song, Void>
    
}

class MAHomeAction: HomeAction {
    
    let store: HomeStore
    let service: HomeService
    
    init(store: HomeStore, service: HomeService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let this = self else { return .empty() }
            return this.service.getHomeInfo()
                .do(onNext: { info in
                    this.store.info.value = info
                })
                .map { _ in }
        }
    }()
    
    func onPageDidSelect() -> Action<Playlist, Void> {
        return Action { [weak self] playlist in
            self?.service.presentPlaylist(playlist) ?? .empty()
        }
    }
    
    func onPlaylistDidSelect() -> Action<Playlist, Void> {
        return Action { [weak self] playlist in
            self?.service.presentPlaylist(playlist) ?? .empty()
        }
    }
    
    func onVideoDidSelect() -> Action<Video, Void> {
        return Action { [weak self] video in
            self?.service.presentVideo(video) ?? .empty()
        }
    }
        
    func onFilmDidSelect() -> Action<Video, Void> {
        return Action { [weak self] film in
            self?.service.presentVideo(film) ?? .empty()
        }
    }
    
    func onTopicDidSelect() -> Action<Topic, Void> {
        return Action { [weak self] topic in
            self?.service.presentTopic(topic) ?? .empty()
        }
    }
    
    func onSongDidSelect() -> Action<Song, Void> {
        return Action { [weak self] song in
            self?.service.play(song) ?? .empty()
        }
    }
    
    func onContextButtonTap() -> Action<Song, Void> {
        return Action { [weak self] song in
            return self?.service.openContextMenu(song) ?? .empty()
        }
    }
    
}
