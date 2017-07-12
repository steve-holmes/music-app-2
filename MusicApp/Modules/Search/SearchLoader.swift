//
//  SearchLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/12/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SearchLoader {

    func search(_ query: String) -> Observable<ItemResponse<SearchInfo>>
    func searchSong(_ query: String) -> Observable<ItemResponse<[Song]>>
    func searchPlaylist(_ query: String) -> Observable<ItemResponse<[Playlist]>>
    func searchVideo(_ query: String) -> Observable<ItemResponse<[Video]>>
    
}

class MASearchLoader: SearchLoader {
    
    func search(_ query: String) -> Observable<ItemResponse<SearchInfo>> {
        return API.search(query: query).json()
            .map { data in
                guard let songs = data["songs"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'songs")
                }
                guard let playlists = data["playlists"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'playlists")
                }
                guard let videos = data["videos"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'videos")
                }
                
                return SearchInfo(
                    songs:      songs.map { Song(json: $0) },
                    playlists:  playlists.map { Playlist(json: $0) },
                    videos:     videos.map { Video(json: $0) }
                )
            }
            .map { .item($0) }
            .startWith(.loading)
    }
    
    func searchSong(_ query: String) -> Observable<ItemResponse<[Song]>> {
        return API.searchSong(query: query).json()
            .map { data in
                guard let songs = data["songs"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'songs")
                }
                return songs.map { Song(json: $0) }
            }
            .map { .item($0) }
            .startWith(.loading)
    }
    
    func searchPlaylist(_ query: String) -> Observable<ItemResponse<[Playlist]>> {
        return API.searchPlaylist(query: query).json()
            .map { data in
                guard let playlists = data["playlists"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'playlists")
                }
                return playlists.map { Playlist(json: $0) }
            }
            .map { .item($0) }
            .startWith(.loading)
    }
    
    func searchVideo(_ query: String) -> Observable<ItemResponse<[Video]>> {
        return API.searchVideo(query: query).json()
            .map { data in
                guard let videos = data["videos"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'videos")
                }
                return videos.map { Video(json: $0) }
            }
            .map { .item($0) }
            .startWith(.loading)
    }
    
}
