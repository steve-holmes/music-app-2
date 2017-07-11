//
//  TopicDetailService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift

protocol TopicDetailService {
    
    var repository: TopicDetailRepository { get }
    var coordinator: TopicDetailCoordinator { get }
    var notification: PlaylistNotification { get }
    
    // MARK: Repository
    
    func getPlaylists(_ topic: Topic) -> Observable<ItemResponse<[Playlist]>>
    func resetPlaylists(_ topic: Topic) -> Observable<ItemResponse<[Playlist]>>
    
    // MARK: Coordinator
    
    func presentPlaylistDetail(_ playlist: Playlist, index: Int, in controller: UIViewController) -> Observable<Void>
    func registerPlaylistPreview(in view: UIView, controller: UIViewController) -> Observable<Void>
    
    // MARK: Notification
    
    func play(_ playlist: Playlist) -> Observable<Void>
    
}

class MATopicDetailService: TopicDetailService {
    
    let repository: TopicDetailRepository
    let coordinator: TopicDetailCoordinator
    let notification: PlaylistNotification
    
    init(repository: TopicDetailRepository, coordinator: TopicDetailCoordinator, notification: PlaylistNotification) {
        self.repository = repository
        self.coordinator = coordinator
        self.notification = notification
    }
    
    // MARK: Repository
    
    func getPlaylists(_ topic: Topic) -> Observable<ItemResponse<[Playlist]>> {
        return repository.getPlaylists(topic)
    }
    
    func resetPlaylists(_ topic: Topic) -> Observable<ItemResponse<[Playlist]>> {
        coordinator.removePlaylistDetailInfos()
        return repository.getPlaylists(topic)
    }
    
    // MARK: Coordinator
    
    func presentPlaylistDetail(_ playlist: Playlist, index: Int, in controller: UIViewController) -> Observable<Void> {
        return coordinator.presentPlaylistDetail(playlist, index: index, in: controller)
    }
    
    func registerPlaylistPreview(in view: UIView, controller: UIViewController) -> Observable<Void> {
        return coordinator.registerPlaylistPreview(in: view, controller: controller)
    }
    
    // MARK: Notification
    
    func play(_ playlist: Playlist) -> Observable<Void> {
        return notification.play(playlist)
    }
    
}
