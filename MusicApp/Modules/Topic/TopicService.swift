//
//  TopicService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol TopicService {
    
    var repository: TopicRepository { get }
    var coordinator: TopicCoordinator { get }
    
    // MARK: Repository
    
    func getTopics() -> Observable<ItemResponse<[Topic]>>
    func resetTopics() -> Observable<ItemResponse<[Topic]>>
    
    // MARK: Coordinator
    
    func presentTopicDetail(_ topic: Topic, index: Int) -> Observable<Void>
    func registerTopicPreview(in view: UIView) -> Observable<Void>
    
}

class MATopicService: TopicService {
    
    let repository: TopicRepository
    let coordinator: TopicCoordinator
    
    init(repository: TopicRepository, coordinator: TopicCoordinator) {
        self.repository = repository
        self.coordinator = coordinator
    }
    
    // MARK: Repository
    
    func getTopics() -> Observable<ItemResponse<[Topic]>> {
        return repository.getTopics()
    }
    
    func resetTopics() -> Observable<ItemResponse<[Topic]>> {
        coordinator.removeTopicDetailInfos()
        return repository.getTopics()
    }
    
    // MARK: Coordinator
    
    func presentTopicDetail(_ topic: Topic, index: Int) -> Observable<Void> {
        return coordinator.presentTopicDetail(topic, index: index)
    }
    
    func registerTopicPreview(in view: UIView) -> Observable<Void> {
        return coordinator.registerTopicPreview(in: view)
    }
    
}
