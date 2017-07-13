//
//  RankModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Swinject

class RankModule: Module {
    
    override func register() {
        
        // MARK: Controller
        
        container.register(RankViewController.self) { resolver in
            let controller = UIStoryboard.rank.controller(of: RankViewController.self)
            
            controller.store = resolver.resolve(RankStore.self)!
            controller.action = resolver.resolve(RankAction.self)!
            
            return controller
        }
        
        container.register(RankStore.self) { resolver in
            return MARankStore()
        }
        
        container.register(RankAction.self) { resolver in
            return MARankAction(
                store: resolver.resolve(RankStore.self)!,
                service: resolver.resolve(RankService.self)!
            )
        }
        
        container.register(RankSongViewController.self) { resolver in
            let controller = UIStoryboard.rank.controller(of: RankSongViewController.self)
            
            controller.store = resolver.resolve(RankSongStore.self)!
            controller.action = resolver.resolve(RankSongAction.self)!
            
            return controller
        }.inObjectScope(.transient)
        
        container.register(RankSongStore.self) { resolver in
            return MARankSongStore()
        }
        
        container.register(RankSongAction.self) { resolver in
            return MARankSongAction(
                store: resolver.resolve(RankSongStore.self)!,
                service: resolver.resolve(RankSongService.self)!
            )
        }
        
        container.register(RankPlaylistViewController.self) { resolver in
            let controller = UIStoryboard.rank.controller(of: RankPlaylistViewController.self)
            
            controller.store = resolver.resolve(RankPlaylistStore.self)!
            controller.action = resolver.resolve(RankPlaylistAction.self)!
            
            return controller
        }.inObjectScope(.transient)
        
        container.register(RankPlaylistStore.self) { resolver in
            return MARankPlaylistStore()
        }
        
        container.register(RankPlaylistAction.self) { resolver in
            return MARankPlaylistAction(
                store: resolver.resolve(RankPlaylistStore.self)!,
                service: resolver.resolve(RankPlaylistService.self)!
            )
        }
        
        container.register(RankVideoViewController.self) { resolver in
            let controller = UIStoryboard.rank.controller(of: RankVideoViewController.self)
            
            controller.store = resolver.resolve(RankVideoStore.self)!
            controller.action = resolver.resolve(RankVideoAction.self)!
            
            return controller
        }.inObjectScope(.transient)
        
        container.register(RankVideoStore.self) { resolver in
            return MARankVideoStore()
        }
        
        container.register(RankVideoAction.self) { resolver in
            return MARankVideoAction(
                store: resolver.resolve(RankVideoStore.self)!,
                service: resolver.resolve(RankVideoService.self)!
            )
        }
        
        // MARK: Domain Model
        
        container.register(RankService.self) { [weak self] resolver in
            let categoryModule = self?.parent?.categoryModule
            return MARankService(
                repository: resolver.resolve(RankRepository.self)!,
                coordinator: resolver.resolve(RankCoordinator.self)!,
                categoryCoordinator: categoryModule!.container.resolve(CategoryCoordinator.self)!
            )
        }.initCompleted { resolver, service in
            var coordinator = service.categoryCoordinator
            coordinator.presentingViewController = resolver.resolve(RankViewController.self)!
            coordinator.subKindVisible = false
        }
        
        container.register(RankRepository.self) { resolver in
            return MARankRepository(
                loader: resolver.resolve(RankLoader.self)!,
                cache: resolver.resolve(ItemCache<RankInfo>.self)!
            )
        }
        
        container.register(ItemCache<RankInfo>.self) { resolver in
            return ItemCache<RankInfo>()
        }
        
        container.register(RankLoader.self) { resolver in
            return MARankLoader()
        }
        
        container.register(RankCoordinator.self) { resolver in
            return MARankCoordinator()
        }.initCompleted { resolver, coordinator in
            let coordinator = coordinator as! MARankCoordinator
            coordinator.sourceViewController = resolver.resolve(RankViewController.self)!
        
            coordinator.getSongController = { return resolver.resolve(RankSongViewController.self) }
            coordinator.getPlaylistController = { return resolver.resolve(RankPlaylistViewController.self) }
            coordinator.getVideoController = { return resolver.resolve(RankVideoViewController.self) }
        }
        
        container.register(RankSongService.self) { resolver in
            let playlistModule = self.parent?.playlistModule
            return MARankSongSerivce(
                repository: resolver.resolve(RankSongRepository.self)!,
                notification: playlistModule!.container.resolve(PlaylistNotification.self)!,
                coordinator: resolver.resolve(RankSongCoordinator.self)!
            )
        }
        
        container.register(RankSongRepository.self) { resolver in
            return MARankSongRepository(
                loader: resolver.resolve(RankSongLoader.self)!
            )
        }
        
        container.register(RankSongLoader.self) { resolver in
            return MARankSongLoader()
        }
        
        container.register(RankSongCoordinator.self) { resolver in
            return MARankSongCoordinator()
        }
        
        container.register(RankPlaylistService.self) { resolver in
            return MARankPlaylistService(
                coordinator: resolver.resolve(RankPlaylistCoordinator.self)!
            )
        }
        
        container.register(RankPlaylistCoordinator.self) { resolver in
            return MARankPlaylistCoordinator()
        }.initCompleted { resolver, coordinator in
            let coordinator = coordinator as! MARankPlaylistCoordinator
            let playlistModule = self.parent?.playlistModule
            coordinator.getDestinationController = { return playlistModule!.container.resolve(PlaylistDetailViewController.self) }
        }
        
        container.register(RankVideoService.self) { resolver in
            return MARankVideoService(
                coordinator: resolver.resolve(RankVideoCoordinator.self)!
            )
        }
        
        container.register(RankVideoCoordinator.self) { resolver in
            return MARankVideoCoordinator()
        }.initCompleted { [weak self] resolver, coordinator in
            let coordinator = coordinator as! MARankVideoCoordinator
            coordinator.getVideoController = {
                self?.parent?.videoModule.container.resolve(VideoDetailViewController.self)
            }
        }
    }
    
}
