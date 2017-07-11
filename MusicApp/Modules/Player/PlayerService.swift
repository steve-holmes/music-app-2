//
//  PlayerService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/24/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift

protocol PlayerService {
    
    var notification: PlayerNotification { get }
    var timerCoordinator: PlayerTimerCoordinator { get }
    
    // MARK: Notification
    
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
    
    // MARK: Coordinator
    
    func presentTimer(in controller: UIViewController, time: Int?) -> Observable<Int?>
    
}

class MAPlayerService: PlayerService {
    
    let notification: PlayerNotification
    let timerCoordinator: PlayerTimerCoordinator
    
    init(notification: PlayerNotification, timerCoordinator: PlayerTimerCoordinator) {
        self.notification = notification
        self.timerCoordinator = timerCoordinator
    }
    
    // MARK: Notification
    
    func play() -> Observable<Void> {
        return notification.play()
    }
    
    func play(track: Track) -> Observable<Void> {
        return notification.play(track: track)
    }
    
    func seek(_ time: Int) -> Observable<Void> {
        return notification.seek(time)
    }
    
    func pause() -> Observable<Void> {
        return notification.pause()
    }
    
    func refresh() -> Observable<Void> {
        return notification.refresh()
    }
    
    func backward() -> Observable<Void> {
        return notification.backward()
    }
    
    func forward() -> Observable<Void> {
        return notification.forward()
    }
    
    func nextRepeat() -> Observable<Void> {
        return notification.nextRepeat()
    }
    
    func onDidPlay() -> Observable<Void> {
        return notification.onDidPlay()
    }
    
    func onDidPause() -> Observable<Void> {
        return notification.onDidPause()
    }
    
    func onDidStop() -> Observable<Void> {
        return notification.onDidStop()
    }
    
    func onDidGetMode() -> Observable<MusicMode> {
        return notification.onDidGetMode()
    }
    
    func onDidGetDuration() -> Observable<Int> {
        return notification.onDidGetDuration()
    }
    
    func onDidGetCurrentTime() -> Observable<Int> {
        return notification.onDidGetCurrentTime()
    }
    
    func onDidGetNextTrack() -> Observable<Track> {
        return notification.onDidGetNextTrack()
    }
    
    func onDidGetTracks() -> Observable<[Track]> {
        return notification.onDidGetTracks()
    }
    
    // MARK: Coordinator
    
    func presentTimer(in controller: UIViewController, time: Int?) -> Observable<Int?> {
        return timerCoordinator.presentTimer(in: controller, time: time)
    }
    
}
