//
//  NotificationName.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/10/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    static var MusicCenterPlaying: Notification.Name { return Notification.Name("MusicCenterPlaying") }
    static var MusicCenterSongPlaying: Notification.Name { return Notification.Name("MusicCenterSongPlaying") }
    static var MusicCenterPlaylistPlaying: Notification.Name { return Notification.Name("MusicCenterPlaylistPlaying") }
    static var MusicCenterTracksPlaying: Notification.Name { return Notification.Name("MusicCenterTracksPlaying") }
    
    static var MusicCenterPlay: Notification.Name { return Notification.Name("MusicCenterPlay") }
    static var MusicCenterPlaySong: Notification.Name { return Notification.Name("MusicCenterPlaySong") }
    static var MusicCenterSeek: Notification.Name { return Notification.Name("MusicCenterSeek") }
    static var MusicCenterPause: Notification.Name { return Notification.Name("MusicCenterPause") }
    static var MusicCenterRefresh: Notification.Name { return Notification.Name("MusicCenterRefresh") }
    static var MusicCenterBackward: Notification.Name { return Notification.Name("MusicCenterBackward") }
    static var MusicCenterForward: Notification.Name { return Notification.Name("MusicCenterForward") }
    static var MusicCenterRepeat: Notification.Name { return Notification.Name("MusicCenterRepeat") }
    static var MusicCenterPlayerIsPlaying: Notification.Name { return Notification.Name("MusicCenterPlayerIsPlaying") }
    
    static var MusicCenterDidGetTracks: Notification.Name { return Notification.Name("MusicCenterDidGetTracks") }
    static var MusicCenterDidGetDuration: Notification.Name { return Notification.Name("MusicCenterDidGetDuration") }
    static var MusicCenterDidGetCurrentTime: Notification.Name { return Notification.Name("MusicCenterDidGetCurrentTime") }
    static var MusicCenterDidGetTrack: Notification.Name { return Notification.Name("MusicCenterDidGetTrack") }
    static var MusicCenterDidGetMode: Notification.Name { return Notification.Name("MusicCenterDidGetMode") }
    static var MusicCenterDidGetIsPlaying: Notification.Name { return Notification.Name("MusicCenterDidGetIsPlaying") }
    
    static var MusicCenterWillPreparePlaying: Notification.Name { return Notification.Name("MusicCenterWillPreparePlaying") }
    static var MusicCenterDidPreparePlaying: Notification.Name { return Notification.Name("MusicCenterDidPreparePlaying") }
    
    static var MusicCenterDidPlay: Notification.Name { return Notification.Name("MusicCenterDidPlay") }
    static var MusicCenterDidPause: Notification.Name { return Notification.Name("MusicCenterDidPause") }
    static var MusicCenterDidStop: Notification.Name { return Notification.Name("MusicCenterDidStop") }
    
}

let kMusicCenterPlaylist        = "playlist"
let kMusicCenterSong            = "song"
let kMusicCenterTracks          = "tracks"
let kMusicCenterSelectedTrack   = "selectedTrack"
let kMusicCenterTrack           = "track"

let kMusicCenterDuration        = "duration"
let kMusicCenterCurrentTime     = "time"

let kMusicCenterMode            = "mode"

let kMusicCenterIsPlaying       = "isPlaying"
