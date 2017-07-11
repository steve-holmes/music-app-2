//
//  PlaylistModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Swinject

class PlaylistModule: Module {
    
    override func register() {
        
        // MARK: Controller
        
        container.register(PlaylistViewController.self) { resolver in
            let controller = UIStoryboard.playlist.controller(of: PlaylistViewController.self)
            
            controller.store = resolver.resolve(PlaylistStore.self)!
            controller.action = resolver.resolve(PlaylistAction.self)!
            
            return controller
        }
        
        container.register(PlaylistStore.self) { resolver in
            return MAPlaylistStore()
        }
        
        container.register(PlaylistAction.self) { resolver in
            return MAPlaylistAction(
                store: resolver.resolve(PlaylistStore.self)!,
                service: resolver.resolve(PlaylistService.self)!
            )
        }
        
        container.register(PlaylistDetailViewController.self) { resolver in
            let controller = UIStoryboard.playlist.controller(of: PlaylistDetailViewController.self)
            
            controller.store = resolver.resolve(PlaylistDetailStore.self)!
            controller.action = resolver.resolve(PlaylistDetailAction.self)!
            
            return controller
        }.inObjectScope(.transient)
        
        container.register(PlaylistDetailStore.self) { resolver in
            return MAPlaylistDetailStore()
        }
        
        container.register(PlaylistDetailAction.self) { resolver in
            return MAPlaylistDetailAction(
                store: resolver.resolve(PlaylistDetailStore.self)!,
                service: resolver.resolve(PlaylistDetailService.self)!
            )
        }
        
        // Domain Model
        
        container.register(PlaylistService.self) { [weak self] resolver in
            let categoryModule = self?.parent?.categoryModule
            return MAPlaylistService(
                repository: resolver.resolve(PlaylistRepository.self)!,
                category: categoryModule!.container.resolve(CategoryRepository.self)!,
                coordinator: resolver.resolve(PlaylistCoordinator.self)!,
                categoryCoordinator: categoryModule!.container.resolve(CategoryCoordinator.self)!,
                notification: resolver.resolve(PlaylistNotification.self)!
            )
        }.initCompleted { resolver, playlistService in
            var coordinator = playlistService.categoryCoordinator
            coordinator.presentingViewController = resolver.resolve(PlaylistViewController.self)!
        }
        
        container.register(PlaylistDetailService.self) { [weak self] resolver in
            let songModule = self?.parent?.songModule
            return MAPlaylistDetailService(
                repository: resolver.resolve(PlaylistRepository.self)!,
                notification: resolver.resolve(PlaylistNotification.self)!,
                songCoordinator: songModule!.container.resolve(SongCoordinator.self)!
            )
        }
        
        container.register(PlaylistRepository.self) { resolver in
            return MAPlaylistRepository(
                loader: resolver.resolve(PlaylistLoader.self)!,
                cache: resolver.resolve(CategoryCache<PlaylistInfo>.self)!
            )
        }
        
        container.register(PlaylistLoader.self) { resolver in
            return MAPlaylistLoader()
        }
        
        container.register(CategoryCache<PlaylistInfo>.self) { resolver in
            return CategoryCache<PlaylistInfo>()
        }
        
        container.register(PlaylistCoordinator.self) { resolver in
            return MAPlaylistCoordinator()
        }.initCompleted { resolver, coordinator in
            let coordinator = coordinator as! MAPlaylistCoordinator
            coordinator.sourceViewController = resolver.resolve(PlaylistViewController.self)!
            coordinator.getDestinationViewController = { resolver.resolve(PlaylistDetailViewController.self)! }
        }
        
        container.register(PlaylistNotification.self) { resolver in
            return MAPlaylistNotification()
        }
    }
    
}
