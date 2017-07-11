//
//  VideoDetailAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action

protocol VideoDetailAction {
    
    var store: VideoDetailStore { get }
    
    var onLoad: Action<Video, Void> { get }
    
    var onStateChange: Action<VideoDetailState, Void> { get }
    
}

class MAVideoDetailAction: VideoDetailAction {
    
    let store: VideoDetailStore
    let service: VideoDetailService
    
    init(store: VideoDetailStore, service: VideoDetailService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: Action<Video, Void> = {
        return Action { [weak self] video in
            guard let this = self else { return .empty() }
            return this.service.getVideoDetail(video)
                .do(onNext: { info in
                    if let info = info {
                        this.store.track.value = info.track
                        this.store.video.value = info.video
                        this.store.others.value = info.others
                        this.store.singers.value = info.singers
                        
                        this.store.state.value = .other
                        this.store.loading.value = false
                    } else {
                        this.store.loading.value = true
                    }
                })
                .map { _ in }
        }
    }()
    
    lazy var onStateChange: Action<VideoDetailState, Void> = {
        return Action { [weak self] state in
            self?.store.state.value = state
            return .empty()
        }
    }()
    
}
