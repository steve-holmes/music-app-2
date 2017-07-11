//
//  SingerDetailService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/21/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SingerDetailService {
    
    var repository: SingerRepository { get }
    var notification: SingerDetailNotification { get }
    var coordinator: SingerDetailCoordinator { get }
    var songCoordinator: SongCoordinator { get }
    
    // MARK: Repository
    
    func getSinger(_ singer: Singer) -> Observable<SingerDetailInfo>
    
    // MARK: Notification
    
    func play(_ song: Song) -> Observable<Void>
    
    // MARK: Coordinator
    
    func presentPlaylist(_ playlist: Playlist, in controller: UIViewController) -> Observable<Void>
    func openContextMenu(_ song: Song, in controller: UIViewController) -> Observable<Void>
    
}

class MASingerDetailService: SingerDetailService {
    
    let repository: SingerRepository
    let notification: SingerDetailNotification
    let coordinator: SingerDetailCoordinator
    let songCoordinator: SongCoordinator
    
    init(repository: SingerRepository, notification: SingerDetailNotification, coordinator: SingerDetailCoordinator, songCoordinator: SongCoordinator) {
        self.repository = repository
        self.notification = notification
        self.coordinator = coordinator
        self.songCoordinator = songCoordinator
    }
    
    // MARK: Repository
    
    func getSinger(_ singer: Singer) -> Observable<SingerDetailInfo> {
        return self.repository.getSinger(singer)
            .map { detailTuple in
                let (songs, playlists, videos) = detailTuple
                return SingerDetailInfo(songs: songs, playlists: playlists, videos: videos)
            }
    }
    
    // MARK: Notification
    
    func play(_ song: Song) -> Observable<Void> {
        return notification.play(song)
    }
    
    // MARK: Coordinator
    
    func presentPlaylist(_ playlist: Playlist, in controller: UIViewController) -> Observable<Void> {
        return coordinator.presentPlaylist(playlist, in: controller)
    }
    
    func openContextMenu(_ song: Song, in controller: UIViewController) -> Observable<Void> {
        return songCoordinator.openContextMenu(song, in: controller)
    }
    
}
