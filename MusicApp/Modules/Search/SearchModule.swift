//
//  File.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/11/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import Swinject

class SearchModule: Module {
    
    override func register() {
        
        // MARK: Controllers
        
        container.register(SearchViewController.self) { resolver in
            let controller = UIStoryboard.search.controller(of: SearchViewController.self)
            
            controller.store = resolver.resolve(SearchStore.self)!
            controller.action = resolver.resolve(SearchAction.self)!
            
            controller.controllers = [
                resolver.resolve(SearchGeneralViewController.self)!,
                resolver.resolve(SearchSongViewController.self)!,
                resolver.resolve(SearchPlaylistViewController.self)!,
                resolver.resolve(SearchVideoViewController.self)!
            ]
            
            return controller
        }
        
        container.register(SearchGeneralViewController.self) { resolver in
            let controller = UIStoryboard.search.controller(of: SearchGeneralViewController.self)
            
            controller.store = resolver.resolve(SearchStore.self)!
            controller.action = resolver.resolve(SearchAction.self)!
            
            return controller
        }
        
        container.register(SearchSongViewController.self) { resolver in
            let controller = UIStoryboard.search.controller(of: SearchSongViewController.self)
            
            controller.store = resolver.resolve(SearchStore.self)!
            controller.action = resolver.resolve(SearchAction.self)!
            
            return controller
        }
        
        container.register(SearchPlaylistViewController.self) { resolver in
            let controller = UIStoryboard.search.controller(of: SearchPlaylistViewController.self)
            
            controller.store = resolver.resolve(SearchStore.self)!
            controller.action = resolver.resolve(SearchAction.self)!
            
            return controller
        }
        
        container.register(SearchVideoViewController.self) { resolver in
            let controller = UIStoryboard.search.controller(of: SearchVideoViewController.self)
            
            controller.store = resolver.resolve(SearchStore.self)!
            controller.action = resolver.resolve(SearchAction.self)!
            
            return controller
        }
        
        container.register(SearchStore.self) { resolver in
            return MASearchStore()
        }
        
        container.register(SearchAction.self) { resolver in
            return MASearchAction(
                store: resolver.resolve(SearchStore.self)!,
                service: resolver.resolve(SearchService.self)!
            )
        }
        
        // MARK: Domain Models
        
        container.register(SearchService.self) { [weak self] resolver in
            let songModule = self?.parent?.songModule
            
            return MASearchService(
                loader: resolver.resolve(SearchLoader.self)!,
                notification: songModule!.container.resolve(SongNotification.self)!,
                coordinator: resolver.resolve(SearchCoordinator.self)!
            )
        }
        
        container.register(SearchLoader.self) { resolver in
            return MASearchLoader()
        }
        
        container.register(SearchCoordinator.self) { resolver in
            return MASearchCoordinator()
        }.initCompleted { [weak self] resolver, coordinator in
            let coordinator = coordinator as! MASearchCoordinator
            coordinator.sourceController = resolver.resolve(SearchViewController.self)
            
            let playlistModule = self?.parent?.playlistModule
            coordinator.getPlaylistController = { playlistModule?.container.resolve(PlaylistDetailViewController.self) }
            
            let videoModule = self?.parent?.videoModule
            coordinator.getVideoController = { videoModule?.container.resolve(VideoDetailViewController.self) }
        }
        
    }
    
}
