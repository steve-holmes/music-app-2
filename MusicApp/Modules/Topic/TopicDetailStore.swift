//
//  TopicDetailStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol TopicDetailStore {
    
    var topic: Variable<Topic> { get }
    var playlists: Variable<[Playlist]> { get }
    
}

class MATopicDetailStore: TopicDetailStore {
    
    let topic = Variable<Topic>(Topic(id: "", name: "", avatar: ""))
    
    let playlists = Variable<[Playlist]>([])
    
}
