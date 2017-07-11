//
//  TopicModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Swinject

class TopicModule: Module {
    
    override func register() {
        
        // MARK: Controllers
        
        container.register(TopicViewController.self) { resolver in
            let controller = UIStoryboard.topic.controller(of: TopicViewController.self)
            
            controller.store = resolver.resolve(TopicStore.self)!
            controller.action = resolver.resolve(TopicAction.self)!
            
            return controller
        }
        
        container.register(TopicStore.self) { resolver in
            return MATopicStore()
        }
        
        container.register(TopicAction.self) { resolver in
            return MATopicAction(
                store: resolver.resolve(TopicStore.self)!,
                service: resolver.resolve(TopicService.self)!
            )
        }
        
        container.register(TopicDetailViewController.self) { resolver in
            let controller = UIStoryboard.topic.controller(of: TopicDetailViewController.self)
            
            controller.store = resolver.resolve(TopicDetailStore.self)!
            controller.action = resolver.resolve(TopicDetailAction.self)!
            
            return controller
        }.inObjectScope(.transient)
        
        container.register(TopicDetailStore.self) { resolver in
            return MATopicDetailStore()
        }
        
        container.register(TopicDetailAction.self) { resolver in
            return MATopicDetailAction(
                store: resolver.resolve(TopicDetailStore.self)!,
                service: resolver.resolve(TopicDetailService.self)!
            )
        }
        
        // MARK: Domain Models
        
        container.register(TopicService.self) { resolver in
            return MATopicService(
                repository: resolver.resolve(TopicRepository.self)!,
                coordinator: resolver.resolve(TopicCoordinator.self)!
            )
        }
        
        container.register(TopicRepository.self) { resolver in
            return MATopicRepository(
                loader: resolver.resolve(TopicLoader.self)!
            )
        }
        
        container.register(TopicLoader.self) { resolver in
            return MATopicLoader()
        }
        
        container.register(TopicCoordinator.self) { resolver in
            return MATopicCoordinator()
            }.initCompleted { resolver, coordinator in
                let coordinator = coordinator as! MATopicCoordinator
                coordinator.sourceViewController = resolver.resolve(TopicViewController.self)!
                coordinator.getDestinationViewController = { resolver.resolve(TopicDetailViewController.self)! }
        }
        
        container.register(TopicDetailService.self) { resolver in
            let playlistModule = self.parent?.playlistModule
            return MATopicDetailService(
                repository: resolver.resolve(TopicDetailRepository.self)!,
                coordinator: resolver.resolve(TopicDetailCoordinator.self)!,
                notification: playlistModule!.container.resolve(PlaylistNotification.self)!
            )
        }
        
        container.register(TopicDetailRepository.self) { resolver in
            return MATopicDetailRepository(
                loader: resolver.resolve(TopicDetailLoader.self)!
            )
        }
        
        container.register(TopicDetailLoader.self) { resolver in
            return MATopicDetailLoader()
        }
        
        container.register(TopicDetailCoordinator.self) { resolver in
            return MATopicDetailCoordinator()
        }.initCompleted { resolver, coordinator in
            let coordinator = coordinator as! MATopicDetailCoordinator
            let playlistModule = self.parent?.playlistModule
            coordinator.getDestinationViewController = { playlistModule!.container.resolve(PlaylistDetailViewController.self)! }
        }
    }
    
}
