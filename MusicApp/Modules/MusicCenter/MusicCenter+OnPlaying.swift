//
//  MusicCenter+OnPlaying.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/19/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import NSObject_Rx

extension MAMusicCenter {
    
    func onPlaying() -> Observable<MusicCenterResponse> {
        return .create { observer in
            if !self.isTracksEmpty {
                observer.onNext(.didPreparePlaying)
                
                let musicTracks = self.dataSource.musicTracks
                observer.onNext(.didGetTracks(musicTracks.tracks))
                observer.onNext(.didGetTrack(musicTracks.selectedTrack))
                
                observer.onCompleted()
                
                return Disposables.create()
            }
            
            observer.onNext(.willPreparePlaying)
            
            let musicTracks = self.rankRepository.getTracks(on: "nhac-viet")
                .take(1)
                .filter { tracks in tracks.count > 0 }
                .map { tracks in MusicTracks(tracks: tracks, selectedTrack: tracks[0]) }
                .shareReplay(1)
            
            self.load(musicTracks)
            self.sendTrackProperties(musicTracks: musicTracks, observer: observer)
            
            return Disposables.create()
        }
    }
    
    func onPlaylistPlaying(_ playlist: Playlist) -> Observable<MusicCenterResponse> {
        return .create { observer in
            observer.onNext(.willPreparePlaying)
            
            let musicTracks = self.playlistRepository.getPlaylist(playlist)
                .take(1)
                .filter { $0.tracks.count > 0 }
                .map { $0.tracks }
                .map { tracks in MusicTracks(tracks: tracks, selectedTrack: tracks[0]) }
                .shareReplay(1)
            
            self.load(musicTracks)
            self.sendTrackProperties(musicTracks: musicTracks, observer: observer)
            
            return Disposables.create()
        }
    }
    
    func onTracks(_ tracks: [Track], selectedTrack: Track) -> Observable<MusicCenterResponse> {
        let responseSubject = BehaviorSubject<MusicCenterResponse>(value: .willPreparePlaying)
        
        load(.just(MusicTracks(tracks: tracks, selectedTrack: selectedTrack)))
        
        let musicTracks = Observable<MusicCenterResponse>.from([
            .willPreparePlaying,
            .didPreparePlaying,
            .didGetTracks(tracks),
            .didGetTrack(selectedTrack)
        ])
        
        return Observable.concat(musicTracks, responseSubject.asObservable().skip(1))
    }
    
    func onSongPlaying(_ song: Song) -> Observable<MusicCenterResponse> {
        return .create { observer in
            observer.onNext(.willPreparePlaying)
            
            let musicTracks = self.songRepository.getSong(song)
                .take(1)
                .map { track in MusicTracks(tracks: [track], selectedTrack: track) }
                .shareReplay(1)
            
            self.load(musicTracks)
            self.sendTrackProperties(musicTracks: musicTracks, observer: observer)
            
            return Disposables.create()
        }
    }
    
    private func sendTrackProperties(musicTracks: Observable<MusicTracks>, observer: AnyObserver<MusicCenterResponse>) {
        musicTracks
            .subscribe(onNext: { _ in observer.onNext(.didPreparePlaying) })
            .addDisposableTo(self.rx_disposeBag)
        
        musicTracks
            .subscribe(onNext: { tracks in observer.onNext(.didGetTracks(tracks.tracks)) })
            .addDisposableTo(rx_disposeBag)
        
        musicTracks
            .subscribe(onNext: { tracks in observer.onNext(.didGetTrack(tracks.selectedTrack)) })
            .addDisposableTo(rx_disposeBag)
        
        musicTracks
            .subscribe(onNext: nil, onError: nil, onCompleted: {
                observer.onCompleted()
            }, onDisposed: nil)
            .addDisposableTo(rx_disposeBag)
    }
    
}
