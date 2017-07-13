//
//  VideoCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol VideoCoordinator {
    
    func presentVideoDetail(_ video: Video) -> Observable<Void>
    
}

class MAVideoCoordinator: VideoCoordinator {
    
    weak var sourceController: VideoViewController?
    var getVideoDetailController: (() -> VideoDetailViewController?)?
    
    func presentVideoDetail(_ video: Video) -> Observable<Void> {
        guard let sourceController = sourceController else { return .empty() }
        guard let destinationController = getVideoDetailController?() else { return .empty() }
        
        destinationController.video = video
        sourceController.show(destinationController, sender: self)
        
        return .empty()
    }
    
}

