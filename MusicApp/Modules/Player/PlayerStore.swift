//
//  PlayerStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol PlayerStore {
    
    var playButtonState: Variable<PlayButtonState> { get }
    var repeatMode: Variable<MusicMode> { get }
    
    var duration: Variable<Int> { get }
    var currentTime: Variable<Int> { get }
    
    var track: Variable<Track> { get }
    var tracks: Variable<[Track]> { get }
    
    var volumeEnabled: Variable<Bool> { get }
    
}

class MAPlayerStore: PlayerStore {
    
    let playButtonState = Variable<PlayButtonState>(.playing)
    let repeatMode = Variable<MusicMode>(.flow)
    
    let duration = Variable<Int>(0)
    let currentTime = Variable<Int>(0)
    
    let track = Variable<Track>(Track(id: "", name: "", singer: "", avatar: "", lyric: "", url: ""))
    let tracks = Variable<[Track]>([])
    
    let volumeEnabled = Variable<Bool>(false)
    
}
