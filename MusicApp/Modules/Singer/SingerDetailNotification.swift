//
//  SingerDetailNotification.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/22/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SingerDetailNotification {
    
    func play(_ song: Song) -> Observable<Void>
    
}

class MASingerDetailNotification: SingerDetailNotification {
    
    func play(_ song: Song) -> Observable<Void> {
        NotificationCenter.default.post(name: .MusicCenterSongPlaying, object: self, userInfo: [kMusicCenterSong: song])
        return .empty()
    }
    
}
