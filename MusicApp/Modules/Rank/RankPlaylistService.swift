//
//  RankPlaylistService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/30/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift

protocol RankPlaylistService {
    
    var coordinator: RankPlaylistCoordinator { get }
    
    func presentPlaylist(_ playlist: Playlist, index: Int, in controller: UIViewController) -> Observable<Void>
    func registerPlaylistPreview(_ sourceView: UIView, in controller: UIViewController) -> Observable<Void>
    
}

class MARankPlaylistService: RankPlaylistService {
    
    let coordinator: RankPlaylistCoordinator
    
    init(coordinator: RankPlaylistCoordinator) {
        self.coordinator = coordinator
    }
    
    func presentPlaylist(_ playlist: Playlist, index: Int, in controller: UIViewController) -> Observable<Void> {
        return coordinator.presentPlaylist(playlist, index: index, in: controller)
    }
    
    func registerPlaylistPreview(_ sourceView: UIView, in controller: UIViewController) -> Observable<Void> {
        return coordinator.registerPlaylistPreview(sourceView, in: controller)
    }
    
}
