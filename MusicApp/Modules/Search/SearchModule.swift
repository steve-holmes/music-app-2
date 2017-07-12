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
        
        container.register(SearchService.self) { resolver in
            return MASearchService(
                loader: resolver.resolve(SearchLoader.self)!
            )
        }
        
        container.register(SearchLoader.self) { resolver in
            return MASearchLoader()
        }
        
    }
    
}
