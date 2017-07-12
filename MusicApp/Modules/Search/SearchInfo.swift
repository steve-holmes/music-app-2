//
//  SearchInfo.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/12/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

struct SearchInfo {
    let songs: [Song]?
    let playlists: [Playlist]?
    let videos: [Video]?
    
    init(songs: [Song]?, playlists: [Playlist]?, videos: [Video]?) {
        self.songs = songs
        self.playlists = playlists
        self.videos = videos
    }
    
    init() {
        self.init(songs: nil, playlists: nil, videos: nil)
    }
    
    init(songs: [Song]) {
        self.init(songs: songs, playlists: nil, videos: nil)
    }
    
    init(playlists: [Playlist]) {
        self.init(songs: nil, playlists: playlists, videos: nil)
    }
    
    init(videos: [Video]) {
        self.init(songs: nil, playlists: nil, videos: videos)
    }
    
}
