//
//  PlaylistDetailInfo.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/19/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

struct PlaylistDetailInfo {
    
    let tracks: [Track]
    let playlists: [Playlist]
    
    var songs: [Song] {
        return tracks.map { Song(id: $0.id, name: $0.name, singer: $0.singer) }
    }
    
}
