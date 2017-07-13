//
//  HomeService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol HomeService {
    
    // MARK: Loader
    
    func getHomeInfo() -> Observable<HomeInfo?>
    
    // MARK: Coordinator
    
    func presentPlaylist(_ playlist: Playlist) -> Observable<Void>
    func presentVideo(_ video: Video) -> Observable<Void>
    func presentTopic(_ topic: Topic) -> Observable<Void>
    
    func openContextMenu(_ song: Song) -> Observable<Void>
    
    // MARK: Notification
    
    func play(_ song: Song) -> Observable<Void>
    
}

class MAHomeService: HomeService {
    
    let loader: HomeLoader
    let coordinator: HomeCoordinator
    let notification: SongNotification
    
    init(loader: HomeLoader, coordinator: HomeCoordinator, notification: SongNotification) {
        self.loader = loader
        self.coordinator = coordinator
        self.notification = notification
    }
    
    // MARK: Loader
    
    func getHomeInfo() -> Observable<HomeInfo?> {
        return loader.getHomeInfo()
            .map { info in
                guard case let .item(homeInfo) = info else { return nil }
                return homeInfo
            }
    }
    
    // MARK: Coordinator
    
    func presentPlaylist(_ playlist: Playlist) -> Observable<Void> {
        return coordinator.presentPlaylist(playlist)
    }
    
    func presentVideo(_ video: Video) -> Observable<Void> {
        return coordinator.presentVideo(video)
    }
    
    func presentTopic(_ topic: Topic) -> Observable<Void> {
        return coordinator.presentTopic(topic)
    }
    
    func openContextMenu(_ song: Song) -> Observable<Void> {
        return coordinator.openContextMenu(song)
    }
    
    // MARK: Notification
    
    func play(_ song: Song) -> Observable<Void> {
        return notification.play(song)
    }
    
}
