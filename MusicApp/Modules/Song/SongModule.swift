//
//  SongModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Swinject
import RxDataSources

class SongModule: Module {
    
    override func register() {
        
        // MARK: Controller
        
        container.register(SongViewController.self) { resolver in
            let controller = UIStoryboard.song.controller(of: SongViewController.self)
            
            controller.store = resolver.resolve(SongStore.self)!
            controller.action = resolver.resolve(SongAction.self)!
            
            return controller
        }
        
        container.register(SongStore.self) { resolver in
            return MASongStore()
        }
        
        container.register(SongAction.self) { resolver in
            return MASongAction(
                store: resolver.resolve(SongStore.self)!,
                service: resolver.resolve(SongService.self)!
            )
        }
        
        // MARK: Domain Model
        
        container.register(SongService.self) { [weak self] resolver in
            let categoryModule = self?.parent?.categoryModule
            
            return MASongService(
                repository: resolver.resolve(SongRepository.self)!,
                category: categoryModule!.container.resolve(CategoryRepository.self)!,
                notification: resolver.resolve(SongNotification.self)!,
                coordinator: resolver.resolve(SongCoordinator.self)!,
                categoryCoordinator: categoryModule!.container.resolve(CategoryCoordinator.self)!
            )
        }.initCompleted { resolver, service in
            var coordinator = service.categoryCoordinator
            coordinator.presentingViewController = resolver.resolve(SongViewController.self)!
        }
        
        container.register(SongRepository.self) { resolver in
            return MASongRepository(
                loader: resolver.resolve(SongLoader.self)!,
                cache: resolver.resolve(CategoryCache<SongInfo>.self)!
            )
        }
        
        container.register(CategoryCache<SongInfo>.self) { resolver in
            return CategoryCache<SongInfo>()
        }
        
        container.register(SongNotification.self) { resolver in
            return MASongNotification()
        }
        
        container.register(SongCoordinator.self) { resolver in
            return MASongCoordinator()
        }
        
        container.register(SongLoader.self) { resolver in
            return MASongLoader()
        }
    }
    
}
