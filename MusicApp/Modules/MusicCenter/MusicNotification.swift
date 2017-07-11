//
//  MusicNotification.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/12/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import Foundation
import RxSwift
import NSObject_Rx

protocol MusicNotification {
    
    func onStartPlaying()
    func onControlPress()
    
}

class MAMusicNotification: NSObject, MusicNotification {
    
    var center: MusicCenter
    
    init(center: MusicCenter) {
        self.center = center
        
        super.init()
        
        onStartPlaying()
        onControlPress()
        
        center.currentTimeOutput
            .subscribe(onNext: { [weak self] currentTime in
                self?.onResponse(.didGetCurrentTime(currentTime))
            })
            .addDisposableTo(rx_disposeBag)
        
        center.durationTimeOutput
            .subscribe(onNext: { [weak self] duration in
                self?.onResponse(.didGetDuration(duration))
            })
            .addDisposableTo(rx_disposeBag)
        
        center.trackOutput
            .subscribe(onNext: { [weak self] track in
                self?.onResponse(.didGetTrack(track))
            })
            .addDisposableTo(rx_disposeBag)
        
        center.modeOutput
            .subscribe(onNext: { [weak self] mode in
                self?.onResponse(.didGetMode(mode))
            })
            .addDisposableTo(rx_disposeBag)
        
        center.didPlayOutput
            .subscribe(onNext: { [weak self] _ in
                self?.onResponse(.didPlay)
            })
            .addDisposableTo(rx_disposeBag)
        
        center.didPauseOutput
            .subscribe(onNext: { [weak self] _ in
                self?.onResponse(.didPause)
            })
            .addDisposableTo(rx_disposeBag)
        
        center.didStopOutput
            .subscribe(onNext: { [weak self] _ in
                self?.onResponse(.didStop)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    fileprivate func subscribe(_ name: Notification.Name, onNext: @escaping (MusicCenter, Notification) -> Void) {
        NotificationCenter.default.rx.notification(name)
            .subscribe(onNext: { [weak self] notification in
                guard let this = self else { return }
                onNext(this.center, notification)
            })
            .addDisposableTo(self.rx_disposeBag)
    }
    
}

// MARK: Playing

extension MAMusicNotification {
    
    func onStartPlaying() {
        subscribe(.MusicCenterPlaying) { center, notification in
            center.onPlaying()
                .subscribe(onNext: { response in
                    self.onResponse(response)
                })
                .addDisposableTo(self.rx_disposeBag)
        }
        
        subscribe(.MusicCenterPlaylistPlaying) { center, notification in
            let playlist = notification.userInfo![kMusicCenterPlaylist] as! Playlist
            
            center.onPlaylistPlaying(playlist)
                .subscribe(onNext: { response in
                    self.onResponse(response)
                })
                .addDisposableTo(self.rx_disposeBag)
        }
        
        subscribe(.MusicCenterTracksPlaying) { center, notification in
            let tracks = notification.userInfo![kMusicCenterTracks] as! [Track]
            let selectedTrack = notification.userInfo![kMusicCenterSelectedTrack] as! Track
            
            center.onTracks(tracks, selectedTrack: selectedTrack)
                .subscribe(onNext: { response in
                    self.onResponse(response)
                })
                .addDisposableTo(self.rx_disposeBag)
        }
        
        subscribe(.MusicCenterSongPlaying) { center, notification in
            let song = notification.userInfo![kMusicCenterSong] as! Song
            
            center.onSongPlaying(song)
                .subscribe(onNext: { response in
                    self.onResponse(response)
                })
                .addDisposableTo(self.rx_disposeBag)
        }
        
        subscribe(.MusicCenterPlayerIsPlaying) { center, notification in
            self.onResponse(.didGetIsPlaying(center.isPlaying))
        }
    }
    
}

// MARK: Controls

extension MAMusicNotification {
    
    func onControlPress() {
        subscribe(.MusicCenterPlay) { center, notification in
            center.onPlay()
        }
        
        subscribe(.MusicCenterPlaySong) { center, notification in
            let track = notification.userInfo![kMusicCenterTrack] as! Track
            center.onPlay(track: track)
        }
        
        subscribe(.MusicCenterSeek) { center, notification in
            let currentTime = notification.userInfo![kMusicCenterCurrentTime] as! Int
            center.onSeek(currentTime)
        }
        
        subscribe(.MusicCenterPause) { center, notification in
            center.onPause()
        }
        
        subscribe(.MusicCenterRefresh) { center, notification in
            center.onRefresh()
        }
        
        subscribe(.MusicCenterBackward) { center, notification in
            center.onBackward()
        }
        
        subscribe(.MusicCenterForward) { center, notification in
            center.onForward()
        }
        
        subscribe(.MusicCenterRepeat) { center, notification in
            center.onRepeat()
        }
    }
    
}

// MARK: Response

extension MAMusicNotification {
    
    fileprivate func onResponse(_ response: MusicCenterResponse) {
        let center = NotificationCenter.default
        
        switch response {
        case .willPreparePlaying:
            center.post(name: .MusicCenterWillPreparePlaying, object: self)
        case .didPreparePlaying:
            center.post(name: .MusicCenterDidPreparePlaying, object: self)
            
        case .didGetTracks(let track):
            center.post(name: .MusicCenterDidGetTracks, object: self, userInfo: [kMusicCenterTracks: track])
            
        case .didGetDuration(let duration):
            center.post(name: .MusicCenterDidGetDuration, object: self, userInfo: [kMusicCenterDuration: duration])
        case .didGetCurrentTime(let currentTime):
            center.post(name: .MusicCenterDidGetCurrentTime, object: self, userInfo: [kMusicCenterCurrentTime: currentTime])
        case .didGetTrack(let track):
            center.post(name: .MusicCenterDidGetTrack, object: self, userInfo: [kMusicCenterTrack: track])
        case .didGetMode(let mode):
            center.post(name: .MusicCenterDidGetMode, object: self, userInfo: [kMusicCenterMode: mode])
        case .didGetIsPlaying(let isPlaying):
            center.post(name: .MusicCenterDidGetIsPlaying, object: self, userInfo: [kMusicCenterIsPlaying: isPlaying])
            
        case .didPlay:
            center.post(name: .MusicCenterDidPlay, object: self)
        case .didPause:
            center.post(name: .MusicCenterDidPause, object: self)
        case .didStop:
            center.post(name: .MusicCenterDidStop, object: self)
        }
    }
    
}
