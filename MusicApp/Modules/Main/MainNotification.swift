//
//  MainNotification.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol MainNotification {
    
    func play() -> Observable<Void>
    
    func onWillPreparePlaying() -> Observable<Void>
    func onDidPreparePlaying() -> Observable<Void>
    
    func onDidPlay() -> Observable<Void>
    func onDidPause() -> Observable<Void>
    
    func onDidGetTrack() -> Observable<Track>
    
}

class MAMainNotification: MainNotification {
    
    func play() -> Observable<Void> {
        NotificationCenter.default.post(name:Notification.Name.MusicCenterPlaying, object: self)
        return .empty()
    }
    
    func onWillPreparePlaying() -> Observable<Void> {
        return NotificationCenter.default.rx.notification(.MusicCenterWillPreparePlaying)
            .map { _ in }
    }
    
    func onDidPreparePlaying() -> Observable<Void> {
        return NotificationCenter.default.rx.notification(.MusicCenterDidPreparePlaying)
            .map { _ in }
    }
    
    func onDidPlay() -> Observable<Void> {
        return NotificationCenter.default.rx.notification(.MusicCenterDidPlay)
            .map { _ in }
    }
    
    func onDidPause() -> Observable<Void> {
        return NotificationCenter.default.rx.notification(.MusicCenterDidPause)
            .map { _ in }
    }
    
    func onDidGetTrack() -> Observable<Track> {
        return NotificationCenter.default.rx.notification(.MusicCenterDidGetTrack)
            .map { notification in
                let track = notification.userInfo![kMusicCenterTrack] as! Track
                return track
            }
    }
    
}
