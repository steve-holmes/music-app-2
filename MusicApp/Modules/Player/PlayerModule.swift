//
//  PlayerModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import Swinject

class PlayerModule: Module {
    
    override func register() {
        
        // MARK: Controllers
        
        container.register(PlayerViewController.self) { resolver in
            let controller = UIStoryboard.player.controller(of: PlayerViewController.self)
            
            controller.store = resolver.resolve(PlayerStore.self)!
            controller.action = resolver.resolve(PlayerAction.self)!
            
            controller.controllers = [
                resolver.resolve(ListPlayerViewController.self)!,
                resolver.resolve(InformationPlayerViewController.self)!,
                resolver.resolve(LyricPlayerViewController.self)!
            ]
            
            controller.timer = resolver.resolve(PlayerTimer.self)!
            
            return controller
        }
        
        container.register(ListPlayerViewController.self) { resolver in
            let controller = UIStoryboard.player.controller(of: ListPlayerViewController.self)
            
            controller.store = resolver.resolve(PlayerStore.self)!
            controller.action = resolver.resolve(PlayerAction.self)!
            
            return controller
        }
        
        container.register(InformationPlayerViewController.self) { resolver in
            let controller = UIStoryboard.player.controller(of: InformationPlayerViewController.self)
            
            controller.store = resolver.resolve(PlayerStore.self)!
            controller.action = resolver.resolve(PlayerAction.self)!
            
            return controller
        }
        
        container.register(LyricPlayerViewController.self) { resolver in
            let controller = UIStoryboard.player.controller(of: LyricPlayerViewController.self)
            
            controller.store = resolver.resolve(PlayerStore.self)!
            controller.action = resolver.resolve(PlayerAction.self)!
            
            controller.lyricStore = resolver.resolve(LyricStore.self)!
            controller.lyricAction = resolver.resolve(LyricAction.self)!
            
            return controller
        }
        
        container.register(PlayerStore.self) { resolver in
            return MAPlayerStore()
        }
        
        container.register(PlayerAction.self) { resolver in
            return MAPlayerAction(
                store: resolver.resolve(PlayerStore.self)!,
                service: resolver.resolve(PlayerService.self)!
            )
        }
        
        container.register(LyricStore.self) { resolver in
            return MALyricStore()
        }
        
        container.register(LyricAction.self) { resolver in
            return MALyricAction(
                store: resolver.resolve(LyricStore.self)!,
                service: resolver.resolve(LyricService.self)!
            )
        }
        
        // MARK: Domain Models
        
        container.register(PlayerService.self) { resolver in
            return MAPlayerService(
                notification: resolver.resolve(PlayerNotification.self)!,
                timerCoordinator: resolver.resolve(PlayerTimerCoordinator.self)!
            )
        }
        
        container.register(LyricService.self) { resolver in
            return MALyricService(
                repository: resolver.resolve(LyricRepository.self)!
            )
        }
        
        container.register(PlayerNotification.self) { resolver in
            return MAPlayerNotification()
        }
        
        container.register(PlayerTimerCoordinator.self) { resolver in
            return MAPlayerTimerCoordinator()
        }
        
        container.register(PlayerTimer.self) { resolver in
            return MAPlayerTimer()
        }.initCompleted { resolver, timer in
            let timer = timer as! MAPlayerTimer
            timer.action = resolver.resolve(PlayerAction.self)!
            timer.controller = resolver.resolve(PlayerViewController.self)!
        }
        
        container.register(LyricRepository.self) { resolver in
            return MALyricRepository(
                loader: resolver.resolve(LyricLoader.self)!
            )
        }
        
        container.register(LyricLoader.self) { resolver in
            return MALyricLoader()
        }
    }
    
}
