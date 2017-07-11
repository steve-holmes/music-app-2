//
//  VideoDetailStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol VideoDetailStore {
    
    var track: Variable<VideoTrack> { get }
    
    var video: Variable<Video> { get }
    
    var others: Variable<[Video]> { get }
    var singers: Variable<[Video]> { get }
    
    var loading: Variable<Bool> { get }
    
    var state: Variable<VideoDetailState> { get }
    
}

class MAVideoDetailStore: VideoDetailStore {
    
    var track = Variable<VideoTrack>(VideoTrack(id: "", name: "", singer: "", avatar: "", url: ""))
    
    let video = Variable<Video>(Video(id: "", name: "", singer: "", avatar: "", time: ""))
    
    let others = Variable<[Video]>([])
    let singers = Variable<[Video]>([])
    
    let loading = Variable<Bool>(false)
    
    let state = Variable<VideoDetailState>(.other)
    
}
