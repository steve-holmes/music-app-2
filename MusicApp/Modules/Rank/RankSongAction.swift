//
//  RankSongAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/30/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action

protocol RankSongAction {
    
    var store: RankSongStore { get }
    
    var onLoad: Action<String, Void> { get }
    
    func onPlayButtonPress() -> CocoaAction
    var onTrackDidSelect: Action<Track, Void> { get }
    
}

class MARankSongAction: RankSongAction {
    
    let store: RankSongStore
    let service: RankSongService
    
    init(store: RankSongStore, service: RankSongService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: Action<String, Void> = {
        return Action { [weak self] country in
            guard let this = self else { return .empty() }
            return this.service.getTracks(country: country)
                .do(onNext: { tracks in
                    this.store.tracks.value = tracks
                })
                .map { _ in }
        }
    }()
    
    func onPlayButtonPress() -> CocoaAction {
        return CocoaAction { [weak self] in
            guard let this = self else { return .empty() }
            return this.service.play(
                tracks: this.store.tracks.value,
                selectedTrack: this.store.tracks.value[0]
            )
        }
    }
    
    lazy var onTrackDidSelect: Action<Track, Void> = {
        return Action { [weak self] track in
            guard let this = self else { return .empty() }
            return this.service.play(
                tracks: this.store.tracks.value,
                selectedTrack: track
            )
        }
    }()
    
}

