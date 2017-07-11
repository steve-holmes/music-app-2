//
//  SingerAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import Action

protocol SingerAction {
    
    var store: SingerStore { get }
    
    var onLoad: Action<String, Void> { get }
    var onPullToRefresh: Action<String, Void> { get }
    var onLoadMore: Action<String, Void> { get }
    
    var onLoadCategories: CocoaAction { get }
    var onCategoriesButtonTap: Action<Void, CategoryInfo?> { get }

    func onSingerDidSelect() -> Action<Singer, Void>
    func onRegisterSingerPreview() -> Action<UIView, Void>
    
}

class MASingerAction: SingerAction {
    
    let store: SingerStore
    let service: SingerService
    
    init(store: SingerStore, service: SingerService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            
            let singerReset = this.service.getSingers(on: category)
                .shareReplay(1)
            
            let singerLoading = singerReset
                .filter { response in
                    if case .loading = response { return true } else { return false }
                }
                .do(onNext: { _ in
                    this.store.singerLoading.value = true
                })
                .map { _ in }
            
            let singerItem = singerReset
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(singerInfo) = info else { return }
                    this.store.singers.value = singerInfo.singers
                    this.store.category.value = singerInfo.category
                    this.store.loadMoreEnabled.value = singerInfo.singers.count > 0
                    this.store.singerLoading.value = false
                })
                .map { _ in }
            
            return Observable.from([singerLoading, singerItem]).merge()
        }
    }()
    
    lazy var onPullToRefresh: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            return this.service.resetSingers(on: category)
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(singerInfo) = info else { return }
                    this.store.singers.value = singerInfo.singers
                    this.store.loadMoreEnabled.value = singerInfo.singers.count > 0
                })
                .map { _ in }
        }
    }()
    
    lazy var onLoadMore: Action<String, Void> = {
        return Action { [weak self] category in
            guard let this = self else { return .empty() }
            return this.service.getNextSingers(on: category)
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(singerInfo) = info else { return }
                    this.store.singers.value = this.store.singers.value + singerInfo.singers
                    this.store.loadMoreEnabled.value = singerInfo.singers.count > 0
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
    
    func onSingerDidSelect() -> Action<Singer, Void> {
        return Action { [weak self] singer in
            guard let this = self else { return .empty() }
            return this.service.presentSingerDetail(
                singer,
                category: this.store.category.value.link,
                index: this.store.singers.value.index(of: singer) ?? 0
            )
        }
    }
    
    func onRegisterSingerPreview() -> Action<UIView, Void> {
        return Action { [weak self] view in
            return self?.service.registerSingerPreview(in: view) ?? .empty()
        }
    }
    
}
