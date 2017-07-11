//
//  RankSongService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/30/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol RankSongService {
    
    var repository: RankSongRepository { get }
    var notification: PlaylistNotification { get }
    
    // MARK: Repository
    
    func getTracks(country: String) -> Observable<[Track]>
    
    // MARK: Notification
    
    func play(tracks: [Track], selectedTrack: Track) -> Observable<Void>
    
}

class MARankSongSerivce: RankSongService {
    
    let repository: RankSongRepository
    let notification: PlaylistNotification
    
    init(repository: RankSongRepository, notification: PlaylistNotification) {
        self.repository = repository
        self.notification = notification
    }
    
    // MARK: Repository
    
    func getTracks(country: String) -> Observable<[Track]> {
        return repository.getTracks(on: country)
    }
    
    // MARK: Notification
    
    func play(tracks: [Track], selectedTrack: Track) -> Observable<Void> {
        return notification.play(tracks: tracks, selectedTrack: selectedTrack)
    }
    
}
