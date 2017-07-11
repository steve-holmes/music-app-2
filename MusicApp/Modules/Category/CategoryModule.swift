//
//  CategoryModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import Swinject

class CategoryModule: Module {
    
    override func register() {
        container.register(CategoryRepository.self) { resolver in
            return MACategoryRepository(
                loader: resolver.resolve(CategoryLoader.self)!
            )
        }
        
        container.register(CategoryLoader.self) { resolver in
            return MACategoryLoader()
        }
        
        container.register(CategoryCoordinator.self) { resolver in
            return MACategoryCoordinator()
        }
    }
    
}
