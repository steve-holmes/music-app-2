//
//  TrackModule.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import Swinject

class TrackModule: Module {
    
    override func register() {
        container.register(TrackRepository.self) { resolver in
            return MATrackRepository()
        }
    }
    
}
