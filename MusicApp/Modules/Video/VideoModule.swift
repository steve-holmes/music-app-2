//
//  VideoModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/10/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Swinject

class VideoModule: Module {
    
    override func register() {
        
        // MARK: Controller
        
        container.register(VideoViewController.self) { resolver in
            let controller = UIStoryboard.video.controller(of: VideoViewController.self)
            
            controller.store = resolver.resolve(VideoStore.self)!
            controller.action = resolver.resolve(VideoAction.self)!
            
            return controller
        }
        
        container.register(VideoStore.self) { resolver in
            return MAVideoStore()
        }
        
        container.register(VideoAction.self) { resolver in
            return MAVideoAction(
                store: resolver.resolve(VideoStore.self)!,
                service: resolver.resolve(VideoService.self)!
            )
        }
        
        container.register(VideoDetailViewController.self) { resolver in
            let controller = UIStoryboard.video.controller(of: VideoDetailViewController.self)
            
            controller.store = resolver.resolve(VideoDetailStore.self)!
            controller.action = resolver.resolve(VideoDetailAction.self)!
            
            controller.player = resolver.resolve(VideoPlayer.self)!
            
            return controller
        }.inObjectScope(.transient)
        
        container.register(VideoDetailStore.self) { resolver in
            return MAVideoDetailStore()
        }
        
        container.register(VideoDetailAction.self) { resolver in
            return MAVideoDetailAction(
                store: resolver.resolve(VideoDetailStore.self)!,
                service: resolver.resolve(VideoDetailService.self)!
            )
        }
        
        // MARK: Domain Model
        
        container.register(VideoService.self) { [weak self] resolver in
            let categoryModule = self?.parent?.categoryModule
            
            return MAVideoService(
                repository: resolver.resolve(VideoRepository.self)!,
                category: categoryModule!.container.resolve(CategoryRepository.self)!,
                categoryCoordinator: categoryModule!.container.resolve(CategoryCoordinator.self)!
            )
        }.initCompleted { resolver, playlistService in
            var coordinator = playlistService.categoryCoordinator
            coordinator.presentingViewController = resolver.resolve(VideoViewController.self)!
        }
        
        container.register(VideoRepository.self) { resolver in
            return MAVideoRepository(
                loader: resolver.resolve(VideoLoader.self)!,
                cache: resolver.resolve(CategoryCache<VideoInfo>.self)!
            )
        }
        
        container.register(CategoryCache<VideoInfo>.self) { resolver in
            return CategoryCache<VideoInfo>()
        }
        
        container.register(VideoLoader.self) { resolver in
            return MAVideoLoader()
        }
        
        container.register(VideoDetailService.self) { resolver in
            return MAVideoDetailService(
                loader: resolver.resolve(VideoDetailLoader.self)!
            )
        }
        
        container.register(VideoDetailLoader.self) { resolver in
            return MAVideoDetailLoader()
        }
        
        container.register(VideoPlayer.self) { resolver in
            return MAVideoPlayer()
        }
    }
    
}
