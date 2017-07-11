//
//  VideoDetailInfo.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

struct VideoDetailInfo {
    let track: VideoTrack
    let others: [Video]
    let singers: [Video]
    
    var video: Video {
        return Video(id: track.id, name: track.name, singer: track.singer, avatar: track.avatar, time: "00:00")
    }
}
