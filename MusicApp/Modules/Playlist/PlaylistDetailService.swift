//
//  PlaylistDetailService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/18/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol PlaylistDetailService {
    
    var repository: PlaylistRepository { get }
    var notification: PlaylistNotification { get }
    var songCoordinator: SongCoordinator { get }
    
    // MARK: Repository
    
    func getPlaylist(_ playlist: Playlist) -> Observable<PlaylistDetailInfo>
    
    // MARK: Coordinator
    
    func openContextMenu(_ song: Song, in controller: UIViewController) -> Observable<Void>
    
    // MARK: Notification
    
    func play(tracks: [Track], selectedTrack: Track) -> Observable<Void>
    
}

class MAPlaylistDetailService: PlaylistDetailService {
    
    let repository: PlaylistRepository
    let notification: PlaylistNotification
    let songCoordinator: SongCoordinator
    
    init(repository: PlaylistRepository, notification: PlaylistNotification, songCoordinator: SongCoordinator) {
        self.repository = repository
        self.notification = notification
        self.songCoordinator = songCoordinator
    }
    
    // MARK: Repository
    
    func getPlaylist(_ playlist: Playlist) -> Observable<PlaylistDetailInfo> {
        return self.repository.getPlaylist(playlist)
            .map { detailTuple in
                let (tracks, playlists) = detailTuple
                return PlaylistDetailInfo(tracks: tracks, playlists: playlists)
            }
    }
    
    // MARK: Coordinator
    
    func openContextMenu(_ song: Song, in controller: UIViewController) -> Observable<Void> {
        return songCoordinator.openContextMenu(song, in: controller)
    }
    
    // MARK: Music Center
    
    func play(tracks: [Track], selectedTrack: Track) -> Observable<Void> {
        return notification.play(tracks: tracks, selectedTrack: selectedTrack)
    }
    
}
