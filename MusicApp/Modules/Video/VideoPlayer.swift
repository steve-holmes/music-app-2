//
//  VideoPlayer.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/4/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import AVFoundation
import RxSwift
import NSObject_Rx

protocol VideoPlayer: class {
    
    var player: AVPlayer? { get }
    weak var delegate: VideoPlayerDelegate? { get set }
    
    var currentTime: Int { get }
    var duration: Int { get }
    
    func load(_ url: String)
    func reload(_ url: String)
    
    func play()
    func play(url: String)
    
    func seek(_ time: Int)
    
    func pause()
    
    func stop()
    
}

class MAVideoPlayer: NSObject, VideoPlayer {
    
    var player: AVPlayer?
    
    weak var delegate: VideoPlayerDelegate?
    
    // MARK: Play Controls
    
    func load(_ url: String) {
        let url = URL(string: url)!
        player = AVPlayer(url: url)
        delegate?.videoPlayerWillLoad(self)
        play()
    }
    
    func reload(_ url: String) {
        stop()
        load(url)
    }
    
    func play() {
        registerObservers()
        player?.play()
        fadeInVolume()
        delegate?.videoPlayerDidPlay(self)
    }
    
    func play(url: String) {
        if player != nil {
            play()
        } else {
            reload(url)
        }
    }
    
    func seek(_ time: Int) {
        delegate?.videoPlayer(self, willSeekToTime: time)
        
        player?.seek(to: CMTimeMake(Int64(time), 1), completionHandler: { [weak self] success in
            guard let this = self else { return }
            
            if success {
                this.delegate?.videoPlayer(this, didSeekToTime: time)
            } else {
                this.delegate?.videoPlayer(this, failSeekToTime: time)
            }
        })
    }
    
    func pause() {
        unregisterObservers()
        self.delegate?.videoPlayerWillPause(self)
        fadeInSubscription?.dispose()
        fadeOutVolume {
            self.player?.pause()
            self.delegate?.videoPlayerDidPause(self)
        }
    }
    
    func stop() {
        unregisterObservers()
        
        player?.pause()
        player?.replaceCurrentItem(with: nil)
        player = nil
        
        delegate?.videoPlayerDidStop(self)
    }
    
    // MARK: De Initialization
    
    deinit {
        unregisterObservers()
        stop()
    }
    
    // MARK: Register/Unregister Observers
    
    private var isObserving: Bool = false
    private var currentTimeObserverToken: Any?
    private var durationObserverToken: Any?
    
    private func registerObservers() {
        if isObserving { return }
        
        addAVPlayerItemDidPlayToEndTimeNotification(player?.currentItem)
        addPeriodicTimeObservers()
        
        isObserving = true
    }
    
    private func unregisterObservers() {
        if !isObserving { return }
        
        removeAVPlayerItemDidPlayToEndTimeNotification(player?.currentItem)
        removePeriodicTimeObservers()
        
        isObserving = false
    }
    
    // MARK: Notification
    
    private func addAVPlayerItemDidPlayToEndTimeNotification(_ playerItem: AVPlayerItem?) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }
    
    private func removeAVPlayerItemDidPlayToEndTimeNotification(_ playerItem: AVPlayerItem?) {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
    }
    
    func playerItemDidReachEnd(_ notification: Notification) {
        pause()
    }
    
    // MARK: Time Observing
    
    var currentTime: Int = 0 {
        didSet {
            delegate?.videoPlayer(self, didGetCurrentTime: currentTime)
        }
    }

    var duration: Int = 0 {
        didSet {
            delegate?.videoPlayer(self, didGetDuration: duration)
        }
    }
    
    private func addPeriodicTimeObservers() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        durationObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let this = self else { return }
            guard let duration = this.player?.currentItem?.duration, duration.isValid && !duration.indefinite else { return }
            
            let seconds = CMTimeGetSeconds(duration)
            self?.duration = Int(seconds)
            
            if let durationToken = self?.durationObserverToken {
                this.player?.removeTimeObserver(durationToken)
                self?.durationObserverToken = nil
            }
        }
        
        currentTimeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let this = self else { return }
            guard let currentTime = this.player?.currentTime(), currentTime.isValid && !currentTime.indefinite else { return }
            
            let seconds = CMTimeGetSeconds(currentTime)
            self?.currentTime = Int(seconds)
        }
    }
    
    private func removePeriodicTimeObservers() {
        if currentTimeObserverToken != nil {
            player?.removeTimeObserver(currentTimeObserverToken!)
        }
        if durationObserverToken != nil {
            player?.removeTimeObserver(durationObserverToken!)
        }
    }
    
    // MARK: Fade in/Fade out volume
    
    private var fadeInSubscription: Disposable?
    private var fadeOutSubscription: Disposable?
    
    private func fadeInVolume(completion: (() -> Void)? = nil) {
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
    
    private func fadeOutVolume(completion: (() -> Void)? = nil) {
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

protocol VideoPlayerDelegate: class {
    
    func videoPlayer(_ player: VideoPlayer, didGetCurrentTime currentTime: Int)
    func videoPlayer(_ player: VideoPlayer, didGetDuration duration: Int)
    
    func videoPlayerWillLoad(_ player: VideoPlayer)
    
    func videoPlayerDidPlay(_ player: VideoPlayer)
    func videoPlayerWillPause(_ player: VideoPlayer)
    func videoPlayerDidPause(_ player: VideoPlayer)
    func videoPlayerDidStop(_ player: VideoPlayer)
    
    func videoPlayer(_ player: VideoPlayer, willSeekToTime time: Int)
    func videoPlayer(_ player: VideoPlayer, failSeekToTime time: Int)
    func videoPlayer(_ player: VideoPlayer, didSeekToTime time: Int)
    
}
