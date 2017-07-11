//
//  VideoAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/10/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action

protocol VideoAction {
    
    var store: VideoStore { get }
    
    var onLoad: Action<String, Void> { get }
    var onPullToRefresh: Action<String, Void> { get }
    var onLoadMore: Action<String, Void> { get }
    
    var onLoadCategories: CocoaAction { get }
    var onCategoriesButtonTap: Action<Void, CategoryInfo?> { get }
    
}

class MAVideoAction: VideoAction {
    
    let store: VideoStore
    let service: VideoService
    
    init(store: VideoStore, service: VideoService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            
            let videoReset = this.service.getVideos(on: category)
                .shareReplay(1)
            
            let videoLoading = videoReset
                .filter { response in
                    if case .loading = response { return true } else { return false }
                }
                .do(onNext: { _ in
                    this.store.videoLoading.value = true
                })
                .map { _ in }
            
            let videoItem = videoReset
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(videoInfo) = info else { return }
                    this.store.videos.value = videoInfo.videos
                    this.store.category.value = videoInfo.category
                    this.store.loadMoreEnabled.value = videoInfo.videos.count > 0
                    this.store.videoLoading.value = false
                })
                .map { _ in }
            
            return Observable.from([videoLoading, videoItem]).merge()
        }
    }()
    
    lazy var onPullToRefresh: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            return this.service.resetVideos(on: category)
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(videoInfo) = info else { return }
                    this.store.videos.value = videoInfo.videos
                    this.store.loadMoreEnabled.value = videoInfo.videos.count > 0
                })
                .map { _ in }
        }
    }()
    
    lazy var onLoadMore: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            return this.service.getNextVideos(on: category)
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(videoInfo) = info else { return }
                    this.store.videos.value = this.store.videos.value + videoInfo.videos
                    this.store.loadMoreEnabled.value = videoInfo.videos.count > 0
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
    
}
