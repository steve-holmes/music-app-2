//
//  MainModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Swinject

class MainModule: Module {
    
    override func register() {
        
        // MARK: Controller
        
        container.register(MainViewController.self) { resolver in
            let controller = UIStoryboard.main.controller(of: MainViewController.self)
            
            controller.store = resolver.resolve(MainStore.self)
            controller.action = resolver.resolve(MainAction.self)
            
            return controller
        }
        
        container.register(MainStore.self) { resolver in
            return MAMainStore()
        }
        
        container.register(MainAction.self) { resolver in
            return MAMainAction(
                store: resolver.resolve(MainStore.self)!,
                service: resolver.resolve(MainService.self)!
            )
        }
        
        // MARK: Domain Model
        
        container.register(MainService.self) { resolver in
            return MAMainService(
                notification: resolver.resolve(MainNotification.self)!,
                coordinator: resolver.resolve(MainCoordinator.self)!
            )
        }
        
        container.register(MainNotification.self) { resolver in
            return MAMainNotification()
        }
        
        container.register(MainCoordinator.self) { resolver in
            return MAMainCoordinator(
                switch: resolver.resolve(MainSwitchCoordinator.self)!,
                modal: resolver.resolve(MainModalCoordinator.self)!
            )
        }
        
        // MARK: Coordinator
        
        container.register(MainSwitchCoordinator.self) {  resolver in
            return MAMainSwitchCoordinator()
        }
        .initCompleted { [weak self] resolver, switchCoordinator in
            let mainController = resolver.resolve(MainViewController.self)!
            let userController = self!.getController(of: UserViewController.self, in: self!.parent!.userModule)
            let onlineController = self!.getController(of: UINavigationController.self, in: self!.parent!.onlineModule)
            
            mainController.addController(userController)
            mainController.addController(onlineController)
            
            (switchCoordinator as? MAMainSwitchCoordinator)?.setMainViewController(mainController)
            
            mainController.loadViewIfNeeded()
            switchCoordinator.switch(to: .right, animated: false)
        }
        
        container.register(MainModalCoordinator.self) { resolver in
            return MAMainModalCoordinator()
        }
        .initCompleted { [weak self] resolver, mainCoordinator in
            let mainController = resolver.resolve(MainViewController.self)!
            let playerController = self?.getController(of: PlayerViewController.self, in: self!.parent!.playerModule)
            
            if let coordinator = mainCoordinator as? MAMainModalCoordinator {
                coordinator.mainViewController = mainController
                coordinator.getPlayerViewController = { return playerController }
            }
        }
    }
    
}
