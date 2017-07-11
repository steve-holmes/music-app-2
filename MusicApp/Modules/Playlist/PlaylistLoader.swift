//
//  PlaylistLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol PlaylistLoader {
    
    func getPlaylists(onCategory category: String, at page: Int) -> Observable<ItemResponse<PlaylistInfo>>
    func getPlaylist(_ playlist: Playlist) -> Observable<(tracks: [Track], playlists: [Playlist])>
    
}

class MAPlaylistLoader: PlaylistLoader {
    
    func getPlaylists(onCategory category: String, at page: Int) -> Observable<ItemResponse<PlaylistInfo>> {
        return API.playlists(category: category, page: page).json()
            .map { data in
                guard let category = data["category"] as? [String:Any] else {
                    fatalError("Can not get the field 'category")
                }
                guard let playlists = data["playlists"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'playlists'")
                }
                return PlaylistInfo(
                    category: CategoryInfo(json: category),
                    playlists: playlists.map { Playlist(json: $0) }
                )
            }
            .map { .item($0) }
            .startWith(.loading)
    }
    
    func getPlaylist(_ playlist: Playlist) -> Observable<(tracks: [Track], playlists: [Playlist])> {
        return API.playlist(id: playlist.id).json()
            .map { data in
                guard let tracks = data["tracks"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'tracks")
                }
                guard let others = data["others"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'others")
                }
                
                return (
                    tracks.map { Track(json: $0) },
                    others.map { Playlist(json: $0) }
                )
            }
    }
    
}
