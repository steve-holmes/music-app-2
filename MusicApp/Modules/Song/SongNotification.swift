//
//  SongNotification.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SongNotification {
    
    func play(_ song: Song) -> Observable<Void>
    
}

class MASongNotification: SongNotification {
    
    func play(_ song: Song) -> Observable<Void> {
        NotificationCenter.default.post(name: .MusicCenterSongPlaying, object: self, userInfo: [kMusicCenterSong: song])
        return Observable.empty()
    }
    
}
