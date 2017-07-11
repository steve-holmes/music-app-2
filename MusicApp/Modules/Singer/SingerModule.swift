//
//  SingerModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Swinject

class SingerModule: Module {
    
    override func register() {
        
        // MARK: Controller
        
        container.register(SingerViewController.self) { resolver in
            let controller = UIStoryboard.singer.controller(of: SingerViewController.self)
            
            controller.store = resolver.resolve(SingerStore.self)!
            controller.action = resolver.resolve(SingerAction.self)!
            
            return controller
        }
        
        container.register(SingerStore.self) { resolver in
            return MASingerStore()
        }
        
        container.register(SingerAction.self) { resolver in
            return MASingerAction(
                store: resolver.resolve(SingerStore.self)!,
                service: resolver.resolve(SingerService.self)!
            )
        }
        
        container.register(SingerDetailViewController.self) { resolver in
            let controller = UIStoryboard.singer.controller(of: SingerDetailViewController.self)
            
            controller.store = resolver.resolve(SingerDetailStore.self)!
            controller.action = resolver.resolve(SingerDetailAction.self)!
            
            return controller
        }.inObjectScope(.transient)
        
        container.register(SingerDetailStore.self) { resolver in
            return MASingerDetailStore()
        }
        
        container.register(SingerDetailAction.self) { resolver in
            return MASingerDetailAction(
                store: resolver.resolve(SingerDetailStore.self)!,
                service: resolver.resolve(SingerDetailService.self)!
            )
        }
        
        // MARK: Domain Model
        
        container.register(SingerService.self) { [weak self] resolver in
            let categoryModule = self?.parent?.categoryModule
            return MASingerService(
                repository: resolver.resolve(SingerRepository.self)!,
                category: categoryModule!.container.resolve(CategoryRepository.self)!,
                coordinator: resolver.resolve(SingerCoordinator.self)!,
                categoryCoordinator: categoryModule!.container.resolve(CategoryCoordinator.self)!
            )
        }.initCompleted { resolver, service in
            var coordinator = service.categoryCoordinator
            coordinator.presentingViewController = resolver.resolve(SingerViewController.self)!
            coordinator.subKindVisible = false
        }
        
        container.register(SingerDetailService.self) { [weak self] resolver in
            let songModule = self?.parent?.songModule
            return MASingerDetailService(
                repository: resolver.resolve(SingerRepository.self)!,
                notification: resolver.resolve(SingerDetailNotification.self)!,
                coordinator: resolver.resolve(SingerDetailCoordinator.self)!,
                songCoordinator: songModule!.container.resolve(SongCoordinator.self)!
            )
        }
        
        container.register(SingerRepository.self) { resolver in
            let categoryModule = self.parent?.categoryModule
            return MASingerRepository(
                loader: resolver.resolve(SingerLoader.self)!,
                cache: resolver.resolve(CategoryCache<SingerInfo>.self)!,
                categoryRepository: categoryModule!.container.resolve(CategoryRepository.self)!
            )
        }
        
        container.register(SingerLoader.self) { resolver in
            return MASingerLoader()
        }
        
        container.register(CategoryCache<SingerInfo>.self) { resolver in
            return CategoryCache<SingerInfo>()
        }
        
        container.register(SingerDetailNotification.self) { resolver in
            return MASingerDetailNotification()
        }
        
        container.register(SingerCoordinator.self) { resolver in
            return MASingerCoordinator()
        }.initCompleted { resolver, coordinator in
            let coordinator = coordinator as! MASingerCoordinator
            coordinator.sourceViewController = resolver.resolve(SingerViewController.self)!
            coordinator.getDestinationViewController = { resolver.resolve(SingerDetailViewController.self)! }
        }
        
        container.register(SingerDetailCoordinator.self) { resolver in
            return MASingerDetailCoordinator()
        }.initCompleted { [weak self] resolver, coordinator in
            let coordinator = coordinator as! MASingerDetailCoordinator
            coordinator.getController = {
                return self?.parent?.playlistModule.container.resolve(PlaylistDetailViewController.self)
            }
        }
    }
    
}
