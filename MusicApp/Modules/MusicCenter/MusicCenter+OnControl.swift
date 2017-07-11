//
//  MusicCenter+OnControl.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/19/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

extension MAMusicCenter {
    
    func onPlay() {
        player.play()
    }
    
    func onPlay(track: Track) {
        dataSource.replaceCurrentTrack(track)
        trackSubject.onNext(track)
        player.reload(track)
    }
    
    func onSeek(_ time: Int) {
        player.seek(time)
    }
    
    func onPause() {
        player.pause()
    }
    
    func onRefresh() {
        let musicTracks = dataSource.musicTracks
        dataSource.musicTracks = musicTracks
        player.reload(musicTracks.selectedTrack)
    }
    
    func onBackward() {
        guard let previousTrack = dataSource.backward() else { return }
        trackSubject.onNext(previousTrack)
        player.reload(previousTrack)
    }
    
    func onForward() {
        guard let nextTrack = dataSource.forward() else { return }
        trackSubject.onNext(nextTrack)
        player.reload(nextTrack)
    }
    
    func onRepeat() {
        let mode = dataSource.nextMode()
        modeSubject.onNext(mode)
    }
    
}
