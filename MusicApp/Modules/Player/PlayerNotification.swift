//
//  PlayerNotification.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/24/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol PlayerNotification {
    
    func play() -> Observable<Void>
    func play(track: Track) -> Observable<Void>
    func seek(_ time: Int) -> Observable<Void>
    func pause() -> Observable<Void>
    func refresh() -> Observable<Void>
    
    func backward() -> Observable<Void>
    func forward() -> Observable<Void>
    
    func nextRepeat() -> Observable<Void>
    
    func onDidPlay() -> Observable<Void>
    func onDidPause() -> Observable<Void>
    func onDidStop() -> Observable<Void>
    
    func onDidGetMode() -> Observable<MusicMode>
    func onDidGetDuration() -> Observable<Int>
    func onDidGetCurrentTime() -> Observable<Int>
    func onDidGetNextTrack() -> Observable<Track>
    func onDidGetTracks() -> Observable<[Track]>
    
}

class MAPlayerNotification: PlayerNotification {
    
    func play() -> Observable<Void> {
        NotificationCenter.default.post(name: .MusicCenterPlay, object: self)
        return .empty()
    }
    
    func play(track: Track) -> Observable<Void> {
        NotificationCenter.default.post(name: .MusicCenterPlaySong, object: self, userInfo: [kMusicCenterTrack: track])
        return .empty()
    }
    
    func seek(_ time: Int) -> Observable<Void> {
        NotificationCenter.default.post(name: .MusicCenterSeek, object: self, userInfo: [kMusicCenterCurrentTime: time])
        return .empty()
    }
    
    func pause() -> Observable<Void> {
        NotificationCenter.default.post(name: .MusicCenterPause, object: self)
        return .empty()
    }
    
    func refresh() -> Observable<Void> {
        NotificationCenter.default.post(name: .MusicCenterRefresh, object: self)
        return .empty()
    }
    
    func backward() -> Observable<Void> {
        NotificationCenter.default.post(name: .MusicCenterBackward, object: self)
        return .empty()
    }
    
    func forward() -> Observable<Void> {
        NotificationCenter.default.post(name: .MusicCenterForward, object: self)
        return .empty()
    }
    
    func nextRepeat() -> Observable<Void> {
        NotificationCenter.default.post(name: .MusicCenterRepeat, object: self)
        return .empty()
    }
    
    func onDidPlay() -> Observable<Void> {
        return NotificationCenter.default.rx.notification(.MusicCenterDidPlay)
            .map { _ in }
    }
    
    func onDidPause() -> Observable<Void> {
        return NotificationCenter.default.rx.notification(.MusicCenterDidPause)
            .map { _ in }
    }
    
    func onDidStop() -> Observable<Void> {
        return NotificationCenter.default.rx.notification(.MusicCenterDidStop)
            .map { _ in }
    }
    
    func onDidGetMode() -> Observable<MusicMode> {
        return NotificationCenter.default.rx.notification(.MusicCenterDidGetMode)
            .map { notification in
                let mode = notification.userInfo![kMusicCenterMode] as! MusicMode
                return mode
            }
    }
    
    func onDidGetDuration() -> Observable<Int> {
        return NotificationCenter.default.rx.notification(.MusicCenterDidGetDuration)
            .map { notification in
                let duration = notification.userInfo![kMusicCenterDuration] as! Int
                return duration
            }
    }
    
    func onDidGetCurrentTime() -> Observable<Int> {
        return NotificationCenter.default.rx.notification(.MusicCenterDidGetCurrentTime)
            .map { notification in
                let currentTime = notification.userInfo![kMusicCenterCurrentTime] as! Int
                return currentTime
            }
    }
    
    func onDidGetNextTrack() -> Observable<Track> {
        return NotificationCenter.default.rx.notification(.MusicCenterDidGetTrack)
            .map { notification in
                let track = notification.userInfo![kMusicCenterTrack] as! Track
                return track
            }
    }
    
    func onDidGetTracks() -> Observable<[Track]> {
        return NotificationCenter.default.rx.notification(.MusicCenterDidGetTracks)
            .map { notification in
                let tracks = notification.userInfo![kMusicCenterTracks] as! [Track]
                return tracks
            }
    }
    
}
