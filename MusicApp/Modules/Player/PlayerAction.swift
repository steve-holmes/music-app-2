//
//  File.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import NotificationBannerSwift
import Action
import NSObject_Rx

protocol PlayerAction {
    
    var store: PlayerStore { get }
    
    func onPlayButtonPress() -> CocoaAction
    func onBackwardPress() -> CocoaAction
    func onForwardPress() -> CocoaAction
    func onRepeatPress() -> CocoaAction
    func onRefreshPress() -> CocoaAction
    
    func onProgressBarDidEndDragging() -> Action<Int, Void>
    
    var onPlay: CocoaAction { get }
    var onPause: CocoaAction { get }
    
    func onHeartButtonPress() -> CocoaAction
    func onDownloadButtonPress() -> CocoaAction
    func onShareButtonPress() -> CocoaAction
    var onCalendarButtonPress: Action<TimerInfo, Int?> { get }
    func onVolumeButtonPress() -> CocoaAction
    
    var onTrackDidSelect: Action<Track, Void> { get }
    
    var onDidPlay: CocoaAction { get }
    var onDidPause: CocoaAction { get }
    var onDidStop: CocoaAction { get }
    
    var onDidGetMode: Action<MusicMode, Void> { get }
    var onDidGetDuration: Action<Int, Void> { get }
    var onDidGetCurrentTime: Action<Int, Void> { get }
    var onDidGetNextTrack: Action<Track, Void> { get }
    var onDidGetTracks: Action<[Track], Void> { get }
    
}

class MAPlayerAction : NSObject, PlayerAction {
    
    let store: PlayerStore
    let service: PlayerService
    
    init(store: PlayerStore, service: PlayerService) {
        self.store = store
        self.service = service
        
        super.init()
        
        self.service.onDidPlay()
            .subscribe(onDidPlay.inputs)
            .addDisposableTo(rx_disposeBag)
        
        self.service.onDidPause()
            .subscribe(onDidPause.inputs)
            .addDisposableTo(rx_disposeBag)
        
        self.service.onDidStop()
            .subscribe(onDidStop.inputs)
            .addDisposableTo(rx_disposeBag)
        
        self.service.onDidGetMode()
            .subscribe(onDidGetMode.inputs)
            .addDisposableTo(rx_disposeBag)
        
        self.service.onDidGetDuration()
            .subscribe(onDidGetDuration.inputs)
            .addDisposableTo(rx_disposeBag)
        
        self.service.onDidGetCurrentTime()
            .subscribe(onDidGetCurrentTime.inputs)
            .addDisposableTo(rx_disposeBag)
        
        self.service.onDidGetNextTrack()
            .subscribe(onDidGetNextTrack.inputs)
            .addDisposableTo(rx_disposeBag)
        
        self.service.onDidGetTracks()
            .subscribe(onDidGetTracks.inputs)
            .addDisposableTo(rx_disposeBag)
    }
    
    func onPlayButtonPress() -> CocoaAction {
        return CocoaAction { [weak self] in
            guard let this = self else { return .empty() }
            
            switch this.store.playButtonState.value {
            case .playing:
                return this.service.pause()
            case .paused:
                return this.service.play()
            }
        }
    }
    
    func onBackwardPress() -> CocoaAction {
        return CocoaAction { [weak self] in
            self?.service.backward() ?? .empty()
        }
    }
    
    func onForwardPress() -> CocoaAction {
        return CocoaAction { [weak self] in
            self?.service.forward() ?? .empty()
        }
    }
    
    func onRepeatPress() -> CocoaAction {
        return CocoaAction { [weak self] in
            self?.service.nextRepeat() ?? .empty()
        }
    }
    
    func onRefreshPress() -> CocoaAction {
        return CocoaAction { [weak self] in
            StatusBarNotificationBanner(title: "Khởi động lại danh sách bài hát", style: .info).show()
            return self?.service.refresh() ?? .empty()
        }
    }
    
    func onProgressBarDidEndDragging() -> Action<Int, Void> {
        return Action { [weak self] currentTime in
            return self?.service.seek(currentTime) ?? .empty()
        }
    }
    
    lazy var onPlay: CocoaAction = {
        return CocoaAction { [weak self] in
            return self?.service.play() ?? .empty()
        }
    }()
    
    lazy var onPause: CocoaAction = {
        return CocoaAction { [weak self] in
            return self?.service.pause() ?? .empty()
        }
    }()
    
    func onHeartButtonPress() -> CocoaAction {
        return CocoaAction {
            return .empty()
        }
    }
    
    func onDownloadButtonPress() -> CocoaAction {
        return CocoaAction {
            return .empty()
        }
    }
    
    func onShareButtonPress() -> CocoaAction {
        return CocoaAction {
            return .empty()
        }
    }
    
    lazy var onCalendarButtonPress: Action<TimerInfo, Int?> = {
        return Action { [weak self] timerInfo in
            return self?.service.presentTimer(in: timerInfo.controller, time: timerInfo.time) ?? .empty()
        }
    }()
    
    func onVolumeButtonPress() -> CocoaAction {
        return CocoaAction { [weak self] in
            self?.store.volumeEnabled.value = !(self?.store.volumeEnabled.value ?? true)
            return .empty()
        }
    }
    
    lazy var onTrackDidSelect: Action<Track, Void> = {
        return Action { [weak self] track in
            self?.store.currentTime.value = 0
            return self?.service.play(track: track) ?? .empty()
        }
    }()
    
    lazy var onDidPlay: CocoaAction = {
        return CocoaAction { [weak self] in
            self?.store.playButtonState.value = .playing
            return .empty()
        }
    }()
    
    lazy var onDidPause: CocoaAction = {
        return CocoaAction { [weak self] in
            self?.store.playButtonState.value = .paused
            return .empty()
        }
    }()
    
    lazy var onDidStop: CocoaAction = {
        return CocoaAction { [weak self] in
            self?.store.playButtonState.value = .paused
            return .empty()
        }
    }()
    
    lazy var onDidGetMode: Action<MusicMode, Void> = {
        return Action { [weak self] mode in
            self?.store.repeatMode.value = mode
            return .empty()
        }
    }()
    
    lazy var onDidGetDuration: Action<Int, Void> = {
        return Action { [weak self] duration in
            self?.store.duration.value = duration
            return .empty()
        }
    }()
    
    lazy var onDidGetCurrentTime: Action<Int, Void> = {
        return Action { [weak self] currentTime in
            self?.store.currentTime.value = currentTime
            return .empty()
        }
    }()
    
    lazy var onDidGetNextTrack: Action<Track, Void> = {
        return Action { [weak self] track in
            self?.store.track.value = track
            return .empty()
        }
    }()
    
    lazy var onDidGetTracks: Action<[Track], Void> = {
        return Action { [weak self] tracks in
            self?.store.tracks.value = tracks
            return .empty()
        }
    }()
    
}
