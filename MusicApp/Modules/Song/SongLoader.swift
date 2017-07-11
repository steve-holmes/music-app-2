//
//  SongLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import RxAlamofire

protocol SongLoader {
    
    func getSongs(onCategory category: String, at page: Int) -> Observable<ItemResponse<SongInfo>>
    func getSong(_ song: Song) -> Observable<Track>
    
}

class MASongLoader: SongLoader {
    
    func getSongs(onCategory category: String, at page: Int) -> Observable<ItemResponse<SongInfo>> {
        return API.songs(category: category, page: page).json()
            .map { data in
                guard let category = data["category"] as? [String:Any] else {
                    fatalError("Can not get the field 'category'")
                }
                guard let songs = data["songs"] as? [[String:Any]] else {
                    fatalError("Can not get the feild 'songs'")
                }
                return SongInfo(
                    category: CategoryInfo(json: category),
                    songs: songs.map { Song(json: $0) }
                )
            }
            .map { .item($0) }
            .startWith(.loading)
    }
    
    func getSong(_ song: Song) -> Observable<Track> {
        return API.song(id: song.id).json()
            .map { data in
                guard let track = data["track"] as? [String:Any] else {
                    fatalError("Can not get the field 'track'")
                }
                return Track(json: track)
            }
    }
    
}
