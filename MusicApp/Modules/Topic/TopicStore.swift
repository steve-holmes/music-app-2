//
//  TopicStore.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol TopicStore {
    
    var topics: Variable<[Topic]> { get }
    
}

class MATopicStore: TopicStore {
    
    let topics = Variable<[Topic]>([])
    
}
