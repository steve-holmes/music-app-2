//
//  PlaylistAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import Action

protocol PlaylistAction {
    
    var store: PlaylistStore { get }
    
    var onLoad: Action<String, Void> { get }
    var onPullToRefresh: Action<String, Void> { get }
    var onLoadMore: Action<String, Void> { get }
    
    var onLoadCategories: CocoaAction { get }
    var onCategoriesButtonTap: Action<Void, CategoryInfo?> { get }
    
    func onPlaylistDidSelect() -> Action<Playlist, Void>
    func onRegisterPlaylistPreview() -> Action<UIView, Void>
    
    func onPlaylistPlayButtonTapped() -> Action<Playlist, Void>
    
}

class MAPlaylistAction: PlaylistAction {
    
    let store: PlaylistStore
    let service: PlaylistService
    
    init(store: PlaylistStore, service: PlaylistService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            
            let playlistReset = this.service.getPlaylists(on: category)
                .shareReplay(1)
            
            let playlistLoading = playlistReset
                .filter { response in
                    if case .loading = response { return true } else { return false }
                }
                .do(onNext: { _ in
                    this.store.playlistLoading.value = true
                })
                .map { _ in }
            
            let playlistItem = playlistReset
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(playlistInfo) = info else { return }
                    this.store.playlists.value = playlistInfo.playlists
                    this.store.category.value = playlistInfo.category
                    this.store.loadMoreEnabled.value = playlistInfo.playlists.count > 0
                    this.store.playlistLoading.value = false
                })
                .map { _ in }
            
            return Observable.from([playlistLoading, playlistItem]).merge()
        }
    }()
    
    lazy var onPullToRefresh: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            return this.service.resetPlaylists(on: category)
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(playlistInfo) = info else { return }
                    this.store.playlists.value = playlistInfo.playlists
                    this.store.loadMoreEnabled.value = playlistInfo.playlists.count > 0
                })
                .map { _ in }
        }
    }()
    
    lazy var onLoadMore: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            return this.service.getNextPlaylists(on: category)
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(playlistInfo) = info else { return }
                    this.store.playlists.value = this.store.playlists.value + playlistInfo.playlists
                    this.store.loadMoreEnabled.value = playlistInfo.playlists.count > 0
                })
                .map { _ in }
        }
    }()
    
    lazy var onLoadCategories: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let this = self else { return .empty() }
            return this.service.getCategories()
                .do(onNext: { categoryInfos in
                    this.store.categories.value = categoryInfos
                })
                .map { _ in }
        }
    }()
    
    lazy var onCategoriesButtonTap: Action<Void, CategoryInfo?> = {
        return Action { [weak self] in
            guard let this = self else { return .empty() }
            return this.service.presentCategories(
                category: this.store.category.value,
                infos: this.store.categories.value
            )
        }
    }()
    
    func onPlaylistDidSelect() -> Action<Playlist, Void> {
        return Action { [weak self] playlist in
            guard let this = self else { return .empty() }
            return this.service.presentPlaylistDetail(
                playlist,
                category: this.store.category.value.link,
                index: this.store.playlists.value.index(of: playlist) ?? 0
            )
        }
    }
    
    func onRegisterPlaylistPreview() -> Action<UIView, Void> {
        return Action { [weak self] view in
            return self?.service.registerPlaylistPreview(in: view) ?? .empty()
        }
    }
    
    func onPlaylistPlayButtonTapped() -> Action<Playlist, Void> {
        return Action { [weak self] playlist in
            return self?.service.play(playlist) ?? .empty()
        }
    }
    
}
