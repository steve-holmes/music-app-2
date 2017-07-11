//
//  HomeLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol HomeLoader {
    
    func getHomeInfo() -> Observable<ItemResponse<HomeInfo>>
    
}

class MAHomeLoader: HomeLoader {
    
    func getHomeInfo() -> Observable<ItemResponse<HomeInfo>> {
        return API.home.json()
            .map { data in
                guard let pages = data["pages"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'pages'")
                }
                guard let playlists = data["playlists"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'playlists'")
                }
                
                guard let videos = data["videos"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'videos'")
                }
                guard let films = data["films"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'films")
                }
                
                guard let topics = data["topics"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'topics'")
                }
                
                guard let songs = data["songs"] as? [[String:Any]] else {
                    fatalError("Can not the field 'songs")
                }
                
                return HomeInfo(
                    pages:      pages.map       { Playlist(json: $0) },
                    playlists:  playlists.map   { Playlist(json: $0) },
                    videos:     videos.map      { Video(json: $0) },
                    films:      films.map       { Video(json: $0) },
                    topics:     topics.map      { Topic(json: $0) },
                    songs:      songs.map       { Song(json: $0) }
                )
            }
            .map { .item($0) }
            .startWith(.loading)
    }
    
}
