//
//  TopicDetailAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import Action

protocol TopicDetailAction {
    
    var store: TopicDetailStore { get }
    
    var onLoad: CocoaAction { get }
    var onPullToRefresh: CocoaAction { get }
    
    var onPlaylistDidSelect: Action<(Playlist, UIViewController), Void> { get }
    var onRegisterPlaylistPreview: Action<(UIView, UIViewController), Void> { get }
    
    func onPlaylistPlayButtonTapped() -> Action<Playlist, Void>
    
}

class MATopicDetailAction: TopicDetailAction {
    
    let store: TopicDetailStore
    let service: TopicDetailService
    
    init(store: TopicDetailStore, service: TopicDetailService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: CocoaAction = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            
            return this.service.getPlaylists(this.store.topic.value)
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(playlists) = info else { return }
                    this.store.playlists.value = playlists
                })
                .map { _ in }
        }
    }()
    
    lazy var onPullToRefresh: CocoaAction = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            return this.service.resetPlaylists(this.store.topic.value)
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(playlists) = info else { return }
                    this.store.playlists.value = playlists
                })
                .map { _ in }
        }
    }()
    
    lazy var onPlaylistDidSelect: Action<(Playlist, UIViewController), Void> = {
        return Action { [weak self] playlist, controller in
            guard let this = self else { return .empty() }
            return this.service.presentPlaylistDetail(
                playlist,
                index: this.store.playlists.value.index(of: playlist) ?? 0,
                in: controller
            )
        }
    }()
    
    lazy var onRegisterPlaylistPreview: Action<(UIView, UIViewController), Void> = {
        return Action { [weak self] view, controller in
            return self?.service.registerPlaylistPreview(in: view, controller: controller) ?? .empty()
        }
    }()
    
    func onPlaylistPlayButtonTapped() -> Action<Playlist, Void> {
        return Action { [weak self] playlist in
            return self?.service.play(playlist) ?? .empty()
        }
    }
    
}
