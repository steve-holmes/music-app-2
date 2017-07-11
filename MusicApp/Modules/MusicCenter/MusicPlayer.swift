//
//  MusicPlayer.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/12/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import AVFoundation
import RxSwift
import NSObject_Rx

protocol MusicPlayer {
    
    var delegate: MusicPlayerDelegate? { get set }
    
    func load(_ track: Track)
    func reload(_ track: Track)
    func stop()
    
    func play()
    func seek(_ time: Int)
    func pause()
    
    var isPlaying: Bool { get }
    
}

protocol MusicPlayerDelegate: class {
    
    func musicPlayer(_ musicPlayer: MusicPlayer, didPlayToEndTime track: Track)
    
    func musicPlayer(_ musicPlayer: MusicPlayer, didGetCurrentTime currentTime: Int)
    func musicPlayer(_ musicPlayer: MusicPlayer, didGetDuration duration: Int)
    
    func musicPlayerDidPlay(_ musicPlayer: MusicPlayer)
    func musicPlayerDidPause(_ musicPlayer: MusicPlayer)
    
}

class MAMusicPlayer: NSObject, MusicPlayer {
    
    // MAKR: Properties
    
    fileprivate var player: AVPlayer?
    fileprivate var track: Track?
    
    fileprivate var isObserving: Bool = false
    
    fileprivate var currentTimeObserverToken: Any?
    fileprivate var durationObserverToken: Any?
    
    // MARK: Delegate Property
    
    weak var delegate: MusicPlayerDelegate?
    
    // MARK: Init
    
    override init() {
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
    }
    
    // MARK: Loading
    
    func load(_ track: Track) {
        unregisterObservers()
        
        let url = URL(string: track.url)!
        let item = AVPlayerItem(url: url)
        player = AVQueuePlayer(playerItem: item)
        
        self.track = track
        
        registerObservers()
    }
    
    func reload(_ track: Track) {
        stop()
        load(track)
    }
    
    // MARK: Stop
    
    func stop() {
        unregisterObservers()
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
    }
    
    // MARK: Play/Pause
    
    fileprivate var fadeInSubscription: Disposable?
    fileprivate var fadeOutSubscription: Disposable?
    
    func play() {
        registerObservers()
    }
    
    func seek(_ time: Int) {
        player?.seek(to: CMTimeMake(Int64(time), 1))
    }
    
    func pause() {
        unregisterObservers()
        self.delegate?.musicPlayerDidPause(self)
        fadeInSubscription?.dispose()
        fadeOutVolume {
            self.player?.pause()
        }
    }
    
    // MARK: Checking
    
    var isPlaying: Bool {
        guard let player = player else { return false }
        return player.status == .readyToPlay && player.rate > 0.0
    }
    
    // MARK: AVPlayerItemDidPlayToEndTime Notification
    
    func playerItemDidReachEnd(_ notification: Notification) {
        guard let currentItem = notification.object as? AVPlayerItem else { return }
        removeAVPlayerItemDidPlayToEndTimeNotification(currentItem)
        
        guard let track = self.track else { return }
        self.delegate?.musicPlayer(self, didPlayToEndTime: track)
    }
    
    // MARK: De Initialization
    
    deinit {
        unregisterObservers()
    }
    
}

// MARK: Register/Unregister Observers

extension MAMusicPlayer {
    
    func registerObservers() {
        if isObserving { return }
        
        player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: .initial, context: nil)
        addAVPlayerItemDidPlayToEndTimeNotification(player?.currentItem)
        addPeriodicTimeObservers()
        
        isObserving = true
    }
    
    func unregisterObservers() {
        if !isObserving { return }
        
        player?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.status))
        removeAVPlayerItemDidPlayToEndTimeNotification(player?.currentItem)
        removePeriodicTimeObservers()
        
        isObserving = false
    }
    
}

// MARK: Notification

extension MAMusicPlayer {
    
    fileprivate func addAVPlayerItemDidPlayToEndTimeNotification(_ playerItem: AVPlayerItem?) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }
    
    fileprivate func removeAVPlayerItemDidPlayToEndTimeNotification(_ playerItem: AVPlayerItem?) {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }
    
}

// MARK: Time Observing

extension MAMusicPlayer {
    
    fileprivate func addPeriodicTimeObservers() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        durationObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let this = self else { return }
            guard let duration = this.player?.currentItem?.duration, duration.isValid && !duration.indefinite else { return }
            
            let seconds = CMTimeGetSeconds(duration)
            self?.delegate?.musicPlayer(this, didGetDuration: Int(seconds))
            
            if let durationToken = self?.durationObserverToken {
                this.player?.removeTimeObserver(durationToken)
                self?.durationObserverToken = nil
            }
        }
        
        currentTimeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let this = self else { return }
            guard let currentTime = this.player?.currentTime(), currentTime.isValid && !currentTime.indefinite else { return }
            
            let seconds = CMTimeGetSeconds(currentTime)
            this.delegate?.musicPlayer(this, didGetCurrentTime: Int(seconds))
        }
    }
    
    fileprivate func removePeriodicTimeObservers() {
        if currentTimeObserverToken != nil {
            player?.removeTimeObserver(currentTimeObserverToken!)
        }
        if durationObserverToken != nil {
            player?.removeTimeObserver(durationObserverToken!)
        }
    }
    
}

// MARK: Key Value Observing

extension MAMusicPlayer {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let player = object as? AVPlayer, player == self.player else { return }
        guard keyPath == #keyPath(AVQueuePlayer.status) else { return }
        
        switch player.status {
        case .readyToPlay:
            print("AVPlayer ReadyToPlay")
            player.play()
            self.delegate?.musicPlayerDidPlay(self)
            fadeOutSubscription?.dispose()
            fadeInVolume()
        case .failed:
            print("AVPlayer Failed")
        case .unknown:
            break
        }
    
    }
    
}

// MARK: Fade in/Fade out volume

extension MAMusicPlayer {
    
    func fadeInVolume(completion: (() -> Void)? = nil) {
        guard let player = self.player else { return }
        
        fadeInSubscription = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
            .take(10)
            .filter { _ in Double(player.volume) < 1.0 }
            .subscribe(
                onNext: { _ in
                    player.volume += 0.1
                },
                onError: nil,
                onCompleted: { completion?() },
                onDisposed: nil
            )
        
        fadeInSubscription?.addDisposableTo(rx_disposeBag)
    }
    
    func fadeOutVolume(completion: (() -> Void)? = nil) {
        guard let player = self.player else { return }
        
        fadeOutSubscription = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
            .take(10)
            .filter { _ in Double(player.volume) > 0.0 }
            .subscribe(
                onNext: { _ in
                    player.volume -= 0.1
                },
                onError: nil,
                onCompleted: { completion?() },
                onDisposed: nil
            )
        
        fadeOutSubscription?.addDisposableTo(rx_disposeBag)
    }
    
}
