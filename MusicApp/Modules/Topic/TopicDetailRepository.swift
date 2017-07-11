//
//  TopicDetailRepository.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol TopicDetailRepository {
    
    func getPlaylists(_ topic: Topic) -> Observable<ItemResponse<[Playlist]>>
    
}

class MATopicDetailRepository: TopicDetailRepository {
    
    let loader: TopicDetailLoader
    
    init(loader: TopicDetailLoader) {
        self.loader = loader
    }
    
    func getPlaylists(_ topic: Topic) -> Observable<ItemResponse<[Playlist]>> {
        return loader.getPlaylists(topic)
    }
    
}
