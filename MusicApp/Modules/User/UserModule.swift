//
//  UserModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import Swinject

class UserModule: Module {
    
    override func register() {
        container.register(UserViewController.self) { resolver in
            let controller = UIStoryboard.user.controller(of: UserViewController.self)
            
            controller.store = resolver.resolve(UserStore.self)!
            controller.action = resolver.resolve(UserAction.self)!
            
            return controller
        }
        
        container.register(UserStore.self) { resolver in
            return MAUserStore()
        }
        
        container.register(UserAction.self) { resolver in
            return MAUserAction(
                store: resolver.resolve(UserStore.self)!
            )
        }
    }
    
}
