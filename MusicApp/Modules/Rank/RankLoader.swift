//
//  RankLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/22/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol RankLoader {
    
    func getRank(on country: String) -> Observable<ItemResponse<(songs: [Song], playlists: [Playlist], videos: [Video])>>
    
}

class MARankLoader: RankLoader {
    
    func getRank(on country: String) -> Observable<ItemResponse<(songs: [Song], playlists: [Playlist], videos: [Video])>> {
        return API.ranks(country: country).json()
            .map { data in
                guard let songs = data["songs"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'songs'")
                }
                guard let playlists = data["playlists"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'playlists'")
                }
                guard let videos = data["videos"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'videos'")
                }
                
                let timedVideos = videos
                    .map { video -> [String:Any] in
                        var newVideo = video
                        newVideo["time"] = "00:00"
                        return newVideo
                    }
                    .map { Video(json: $0) }
                
                return (
                    songs:      songs.map { Song(json: $0) },
                    playlists:  playlists.map { Playlist(json: $0) },
                    videos:     timedVideos
                )
            }
            .map { .item($0) }
            .startWith(.loading)
    }
    
}
