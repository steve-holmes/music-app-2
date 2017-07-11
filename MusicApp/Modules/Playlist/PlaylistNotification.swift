//
//  PlaylistNotification.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/19/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol PlaylistNotification {
    
    func play(_ playlist: Playlist) -> Observable<Void>
    func play(tracks: [Track], selectedTrack: Track) -> Observable<Void>
    
}

class MAPlaylistNotification: PlaylistNotification {
    
    func play(_ playlist: Playlist) -> Observable<Void> {
        NotificationCenter.default.post(name: .MusicCenterPlaylistPlaying, object: self, userInfo: [kMusicCenterPlaylist: playlist])
        return .empty()
    }
    
    func play(tracks: [Track], selectedTrack: Track) -> Observable<Void> {
        NotificationCenter.default.post(
            name: .MusicCenterTracksPlaying,
            object: self,
            userInfo: [kMusicCenterTracks: tracks, kMusicCenterSelectedTrack: selectedTrack]
        )
        return .empty()
    }
    
}
