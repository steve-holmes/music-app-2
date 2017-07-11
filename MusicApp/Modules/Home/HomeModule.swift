//
//  HomeModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Swinject

class HomeModule: Module {
    
    override func register() {
        
        // MARK: Controllers
        
        container.register(HomeViewController.self) { resolver in
            let controller = UIStoryboard.home.controller(of: HomeViewController.self)
            
            controller.store = resolver.resolve(HomeStore.self)!
            controller.action = resolver.resolve(HomeAction.self)!
            
            return controller
        }
        
        container.register(HomeStore.self) { resolver in
            return MAHomeStore()
        }
        
        container.register(HomeAction.self) { resolver in
            return MAHomeAction(
                store: resolver.resolve(HomeStore.self)!,
                service: resolver.resolve(HomeService.self)!
            )
        }
        
        // MARK: Domain Models
        
        container.register(HomeService.self) { [weak self] resolver in
            let songModule = self?.parent?.songModule
            return MAHomeService(
                loader: resolver.resolve(HomeLoader.self)!,
                coordinator: resolver.resolve(HomeCoordinator.self)!,
                notification: songModule!.container.resolve(SongNotification.self)!
            )
        }
        
        container.register(HomeLoader.self) { resolver in
            return MAHomeLoader()
        }
        
        container.register(HomeCoordinator.self) { resolver in
            return MAHomeCoordinator()
        }.initCompleted { [weak self] resolver, coordinator in
            let coordinator = coordinator as! MAHomeCoordinator
            coordinator.sourceController = resolver.resolve(HomeViewController.self)!
            
            let playlistModule = self?.parent?.playlistModule
            coordinator.getPlaylistController = { playlistModule?.container.resolve(PlaylistDetailViewController.self) }
            
            let videoModule = self?.parent?.videoModule
            coordinator.getVideoController = { videoModule?.container.resolve(VideoDetailViewController.self) }
            
            let topicModule = self?.parent?.topicModule
            coordinator.getTopicController = { topicModule?.container.resolve(TopicDetailViewController.self) }
        }
    }
    
}
