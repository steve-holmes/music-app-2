//
//  RankVideoAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action

protocol RankVideoAction {
    
    var store: RankVideoStore { get }
    
    var videoDidSelect: Action<(Video, UIViewController), Void> { get }
    
}

class MARankVideoAction: RankVideoAction {
    
    let store: RankVideoStore
    let service: RankVideoService
    
    init(store: RankVideoStore, service: RankVideoService) {
        self.store = store
        self.service = service
    }
    
    lazy var videoDidSelect: Action<(Video, UIViewController), Void> = {
        return Action { [weak self] info in
            let (video, controller) = info
            return self?.service.presentVideo(video, in: controller) ?? .empty()
        }
    }()
    
}
