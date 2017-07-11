//
//  SongAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import Action

protocol SongAction {
    
    var store: SongStore { get }
    
    var onLoad: Action<String, Void> { get }
    var onPullToRefresh: Action<String, Void> { get }
    var onLoadMore: Action<String, Void> { get }
    
    var onLoadCategories: CocoaAction { get }
    var onCategoriesButtonTap: Action<Void, CategoryInfo?> { get }
    
    var onContextButtonTap: Action<(Song, UIViewController), Void> { get }
    
    var onSongDidSelect: Action<Song, Void> { get }
    
}

class MASongAction: NSObject, SongAction {
    
    let store: SongStore
    let service: SongService
    
    init(store: SongStore, service: SongService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            
            let songReset = this.service.getSongs(on: category)
                .shareReplay(1)
            
            let songLoading = songReset
                .filter { response in
                    if case .loading = response { return true } else { return false }
                }
                .do(onNext: { _ in
                    this.store.songLoading.value = true
                })
                .map { _ in }
            
            let songItem = songReset
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(songInfo) = info else { return }
                    this.store.songs.value = songInfo.songs
                    this.store.category.value = songInfo.category
                    this.store.loadMoreEnabled.value = songInfo.songs.count > 0
                    this.store.songLoading.value = false
                })
                .map { _ in }
            
            return Observable.from([songLoading, songItem]).merge()
        }
    }()
    
    lazy var onPullToRefresh: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            return this.service.resetSongs(on: category)
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(songInfo) = info else { return }
                    this.store.songs.value = songInfo.songs
                    this.store.loadMoreEnabled.value = songInfo.songs.count > 0
                })
                .map { _ in }
        }
    }()
    
    lazy var onLoadMore: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            return this.service.getNextSongs(on: category)
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(songInfo) = info else { return }
                    this.store.songs.value = this.store.songs.value + songInfo.songs
                    this.store.loadMoreEnabled.value = songInfo.songs.count > 0
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
    
    lazy var onContextButtonTap: Action<(Song, UIViewController), Void> = {
        return Action { [weak self] contextInfo in
            guard let this = self else { return .empty() }
            let (song, controller) = contextInfo
            return this.service.openContextMenu(song, in: controller)
        }
    }()
    
    lazy var onSongDidSelect: Action<Song, Void> = {
        return Action { [weak self] song in
            return self?.service.play(song) ?? .empty()
        }
    }()
    
}
