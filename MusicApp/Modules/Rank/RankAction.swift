//
//  RankAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import Action

protocol RankAction {
    
    var store: RankStore { get }
    
    var onLoad: Action<String, Void> { get }
    var onPullToRefresh: Action<String, Void> { get }
    
    var onLoadCategories: CocoaAction { get }
    var onCategoriesButtonTap: Action<Void, CategoryInfo?> { get }
    
    var onSongCellTap: CocoaAction { get }
    var onPlaylistCellTap: CocoaAction { get }
    var onVideoCellTap: CocoaAction { get }
    
}

class MARankAction: RankAction {
    
    let store: RankStore
    let service: RankService
    
    init(store: RankStore, service: RankService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            return this.service.getRank(on: category)
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(rankInfo) = info else { return }
                    this.store.category.value = rankInfo.category
                    this.store.songs.value = rankInfo.songs
                    this.store.playlists.value = rankInfo.playlists
                    this.store.videos.value = rankInfo.videos
                })
                .map { _ in }
        }
    }()
    
    lazy var onPullToRefresh: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            return this.service.resetRank(on: category)
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(rankInfo) = info else { return }
                    this.store.songs.value = rankInfo.songs
                    this.store.playlists.value = rankInfo.playlists
                    this.store.videos.value = rankInfo.videos
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
    
    lazy var onSongCellTap: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let this = self else { return .empty() }
            return this.service.presentSong(country: this.store.category.value.link)
        }
    }()
    
    lazy var onPlaylistCellTap: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let this = self else { return .empty() }
            return this.service.presentPlaylist(this.store.playlists.value, country: this.store.category.value.link)
        }
    }()
    
    lazy var onVideoCellTap: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let this = self else { return .empty() }
            return this.service.presentVideo(this.store.videos.value, country: this.store.category.value.link)
        }
    }()
    
}
