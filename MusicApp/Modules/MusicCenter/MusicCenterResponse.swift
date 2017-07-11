//
//  MusicCenterResponse.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/19/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

enum MusicCenterResponse {
    
    case willPreparePlaying
    case didPreparePlaying
    
    case didGetTracks([Track])
    
    case didGetDuration(Int)
    case didGetCurrentTime(Int)
    case didGetTrack(Track)
    case didGetMode(MusicMode)
    case didGetIsPlaying(Bool)
    
    case didPlay
    case didPause
    case didStop
    
}
