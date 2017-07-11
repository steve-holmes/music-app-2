//
//  TopicAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import Action

protocol TopicAction {
    
    var store: TopicStore { get }
    
    var onLoad: CocoaAction { get }
    var onPullToRefresh: CocoaAction { get }
    
    var onTopicDidSelect: Action<Topic, Void> { get }
    var onRegisterTopicPreview: Action<UIView, Void> { get }
    
}

class MATopicAction: TopicAction {
    
    let store: TopicStore
    let service: TopicService
    
    init(store: TopicStore, service: TopicService) {
        self.store = store
        self.service = service
    }
    
    lazy var onLoad: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let this = self else { return .empty() }
            
            return this.service.getTopics()
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(topics) = info else { return }
                    this.store.topics.value = topics
                })
                .map { _ in }
        }
    }()
    
    lazy var onPullToRefresh: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let this = self else { return .empty() }
            return this.service.resetTopics()
                .filter { response in
                    if case .item(_) = response { return true } else { return false }
                }
                .do(onNext: { info in
                    guard case let .item(topics) = info else { return }
                    this.store.topics.value = topics
                })
                .map { _ in }
        }
    }()
    
    lazy var onTopicDidSelect: Action<Topic, Void> = {
        return Action { [weak self] topic in
            guard let this = self else { return .empty() }
            return this.service.presentTopicDetail(
                topic,
                index: this.store.topics.value.index(of: topic) ?? 0
            )
        }
    }()
    
    lazy var onRegisterTopicPreview: Action<UIView, Void> = {
        return Action { [weak self] view in
            return self?.service.registerTopicPreview(in: view) ?? .empty()
        }
    }()
    
}
