//
//  TopicDetailLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol TopicDetailLoader {
    
    func getPlaylists(_ topic: Topic) -> Observable<ItemResponse<[Playlist]>>
    
}

class MATopicDetailLoader: TopicDetailLoader {
    
    func getPlaylists(_ topic: Topic) -> Observable<ItemResponse<[Playlist]>> {
        return API.topic(id: topic.id).json()
            .map { data in
                guard let playlists = data["playlists"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'playlists'")
                }
                return playlists.map { Playlist(json: $0) }
            }
            .map { .item($0) }
            .startWith(.loading)
    }
    
}
