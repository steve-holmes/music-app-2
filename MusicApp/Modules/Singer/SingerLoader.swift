//
//  SingerLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SingerLoader {
    
    func getHotSingers() -> Observable<ItemResponse<[Singer]>>
    func getSingers(on category: String, at page: Int) -> Observable<ItemResponse<[Singer]>>
    func getSinger(_ singer: Singer) -> Observable<(songs: [Song], playlists: [Playlist], videos: [Video])>
    
}

class MASingerLoader: SingerLoader {

    func getHotSingers() -> Observable<ItemResponse<[Singer]>> {
        return API.hotSingers.json()
            .map(self.getSingers(from:))
            .map { .item($0) }
            .startWith(.loading)
    }
    
    func getSingers(on category: String, at page: Int) -> Observable<ItemResponse<[Singer]>> {
        return API.singers(category: category, page: page).json()
            .map(self.getSingers(from:))
            .map { .item($0) }
            .startWith(.loading)
    }
    
    private func getSingers(from data: [String:Any]) -> [Singer] {
        guard let singers = data["singers"] as? [[String:Any]] else {
            fatalError("Can not get the field 'singers'")
        }
        return singers.map { Singer(json: $0) }
    }
    
    func getSinger(_ singer: Singer) -> Observable<(songs: [Song], playlists: [Playlist], videos: [Video])> {
        return API.singer(id: singer.id).json()
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
                
                return (
                    songs.map { Song(json: $0) },
                    playlists.map { Playlist(json: $0) },
                    videos.map { Video(json: $0) }
                )
        }
    }
    
}
