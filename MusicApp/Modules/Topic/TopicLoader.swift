//
//  TopicLoader.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol TopicLoader {
    
    func getTopics() -> Observable<ItemResponse<[Topic]>>
    
}

class MATopicLoader: TopicLoader {
    
    func getTopics() -> Observable<ItemResponse<[Topic]>> {
        return API.topics.json()
            .map { data in
                guard let topics = data["topics"] as? [[String:Any]] else {
                    fatalError("Can not get the field 'topics'")
                }
                return topics.map { Topic(json: $0) }
            }
            .map { .item($0) }
            .startWith(.loading)
    }
    
}
