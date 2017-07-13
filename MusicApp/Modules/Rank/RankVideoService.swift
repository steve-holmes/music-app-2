//
//  RankVideoService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/30/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol RankVideoService {
    
    func presentVideo(_ video: Video, in controller: UIViewController) -> Observable<Void>
    
}

class MARankVideoService: RankVideoService {
    
    let coordinator: RankVideoCoordinator
    
    init(coordinator: RankVideoCoordinator) {
        self.coordinator = coordinator
    }
    
    func presentVideo(_ video: Video, in controller: UIViewController) -> Observable<Void> {
        return coordinator.presentVideo(video, in: controller)
    }
    
}
