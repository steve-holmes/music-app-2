//
//  TopicRepository.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol TopicRepository {
    
    func getTopics() -> Observable<ItemResponse<[Topic]>>
    
}

class MATopicRepository: TopicRepository {
    
    let loader: TopicLoader
    
    init(loader: TopicLoader) {
        self.loader = loader
    }
    
    func getTopics() -> Observable<ItemResponse<[Topic]>> {
        return loader.getTopics()
    }
    
}
