//
//  MusicCenter.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/10/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import NSObject_Rx

protocol MusicCenter {
    
    var dataSource: MusicTrackDataSource { get }
    var player: MusicPlayer { get }
    
    var currentTimeOutput: Observable<Int> { get }
    var durationTimeOutput: Observable<Int> { get }
    var trackOutput: Observable<Track> { get }
    var modeOutput: Observable<MusicMode> { get }
    
    var didPlayOutput: Observable<Void> { get }
    var didPauseOutput: Observable<Void> { get }
    var didStopOutput: Observable<Void> { get }
    
    var isTracksEmpty: Bool { get }
    var isPlaying: Bool { get }
    
    func onPlaying()                                        -> Observable<MusicCenterResponse>
    func onPlaylistPlaying(_ playlist: Playlist)            -> Observable<MusicCenterResponse>
    func onTracks(_ tracks: [Track], selectedTrack: Track)  -> Observable<MusicCenterResponse>
    func onSongPlaying(_ song: Song)                        -> Observable<MusicCenterResponse>
    
    func onPlay()
    func onPlay(track: Track)
    func onSeek(_ time: Int)
    func onPause()
    func onRefresh()
    func onBackward()
    func onForward()
    func onRepeat()
    
}

class MAMusicCenter: NSObject, MusicCenter {
    
    var dataSource: MusicTrackDataSource
    var player: MusicPlayer
    
    let playlistRepository: PlaylistRepository
    let songRepository: SongRepository
    let rankRepository: RankSongRepository
    
    init(dataSource: MusicTrackDataSource, player: MusicPlayer, playlistRepository: PlaylistRepository, songRepository: SongRepository, rankRepository: RankSongRepository) {
        self.dataSource = dataSource
        self.player = player
        self.playlistRepository = playlistRepository
        self.songRepository = songRepository
        self.rankRepository = rankRepository
        
        super.init()
        
        self.player.delegate = self
    }
    
    // MARK: Outputs
    
    fileprivate let currentTimeSubject = PublishSubject<Int>()
    fileprivate let durationSubject = PublishSubject<Int>()
    let trackSubject = PublishSubject<Track>()
    let modeSubject = PublishSubject<MusicMode>()
    fileprivate let didPlaySubject = PublishSubject<Void>()
    fileprivate let didPauseSubject = PublishSubject<Void>()
    fileprivate let didStopSubject = PublishSubject<Void>()
    
    lazy var currentTimeOutput: Observable<Int> = { return self.currentTimeSubject.asObservable() }()
    lazy var durationTimeOutput: Observable<Int> = { return self.durationSubject.asObservable() }()
    lazy var trackOutput: Observable<Track> = { return self.trackSubject.asObservable() }()
    lazy var modeOutput: Observable<MusicMode> = { return self.modeSubject.asObservable() }()
    lazy var didPlayOutput: Observable<Void> = { return self.didPlaySubject.asObservable() }()
    lazy var didPauseOutput: Observable<Void> = { return self.didPauseSubject.asObservable() }()
    lazy var didStopOutput: Observable<Void> = { return self.didStopSubject.asObservable() }()
    
    // MARK: Validation
    
    var isTracksEmpty: Bool {
        return dataSource.isEmpty
    }
    
    var isPlaying: Bool {
        return player.isPlaying
    }
    
    // MARK: Loading
    
    func load(_ musicTracks: Observable<MusicTracks>) {
        musicTracks
            .subscribe(onNext: { [weak self] musicTracks in
                self?.dataSource.musicTracks = musicTracks
                self?.player.load(musicTracks.selectedTrack)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
}

extension MAMusicCenter: MusicPlayerDelegate {
    
    func musicPlayer(_ musicPlayer: MusicPlayer, didGetCurrentTime currentTime: Int) {
        currentTimeSubject.onNext(currentTime)
    }
    
    func musicPlayer(_ musicPlayer: MusicPlayer, didGetDuration duration: Int) {
        durationSubject.onNext(duration)
    }
    
    func musicPlayer(_ musicPlayer: MusicPlayer, didPlayToEndTime track: Track) {
        if let track = dataSource.nextTrack() {
            player.load(track)
            trackSubject.onNext(track)
        } else {
            player.stop()
            didStopSubject.onNext(())
        }
    }
    
    func musicPlayerDidPlay(_ musicPlayer: MusicPlayer) {
        didPlaySubject.onNext(())
    }
    
    func musicPlayerDidPause(_ musicPlayer: MusicPlayer) {
        didPauseSubject.onNext(())
    }
    
}
