//
//  LyricAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/25/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action

protocol LyricAction {
    
    var store: LyricStore { get }
    
    var onLoad: Action<String, Void> { get }
    var onLyricIndexChange: Action<Int, Void> { get }
    func onLyricAutoScrollingChange() -> CocoaAction
    
}

class MALyricAction: LyricAction {
    
    let store: LyricStore
    let service: LyricService
    
    init(store: LyricStore, service: LyricService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: Action<String, Void> = {
        return Action { [weak self] lyricURL in
            guard let this = self else { return .empty() }
            return this.service.load(lyricURL)
                .do(onNext: { lyrics in
                    this.store.lyrics.value = lyrics
                })
                .map { _ in }
        }
    }()
    
    lazy var onLyricIndexChange: Action<Int, Void> = {
        return Action { [weak self] lyricIndex in
            self?.store.index.value = lyricIndex
            return .empty()
        }
    }()
    
    func onLyricAutoScrollingChange() -> CocoaAction {
        return CocoaAction { [weak self] in
            self?.store.autoScrolling.value = !(self?.store.autoScrolling.value ?? false)
            return .empty()
        }
    }
    
}
