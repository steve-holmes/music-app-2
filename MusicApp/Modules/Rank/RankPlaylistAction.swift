//
//  RankPlaylistAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action

protocol RankPlaylistAction {
    
    var store: RankPlaylistStore { get }
    
    var presentPlaylistDetail: Action<(Playlist, UIViewController), Void> { get }
    var registerPlaylistPreview: Action<(UIView, UIViewController), Void> { get }
}

class MARankPlaylistAction: RankPlaylistAction {
    
    let store: RankPlaylistStore
    let service: RankPlaylistService
    
    init(store: RankPlaylistStore, service: RankPlaylistService) {
        self.store = store
        self.service = service
    }
    
    lazy var presentPlaylistDetail: Action<(Playlist, UIViewController), Void> = {
        return Action { [weak self] playlist, controller in
            guard let this = self else { return .empty() }
            return this.service.presentPlaylist(
                playlist,
                index: this.store.playlists.value.index(of: playlist)!,
                in: controller
            )
        }
    }()
    
    lazy var registerPlaylistPreview: Action<(UIView, UIViewController), Void> = {
        return Action { [weak self] sourceView, controller in
            return self?.service.registerPlaylistPreview(sourceView, in: controller) ?? .empty()
        }
    }()
    
}
