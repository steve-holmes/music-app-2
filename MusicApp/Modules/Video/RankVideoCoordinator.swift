//
//  RankVideoCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol RankVideoCoordinator {
    
    func presentVideo(_ video: Video, in controller: UIViewController) -> Observable<Void>
    
}

class MARankVideoCoordinator: RankVideoCoordinator {
    
    var getVideoController: (() -> VideoDetailViewController?)?
    
    func presentVideo(_ video: Video, in controller: UIViewController) -> Observable<Void> {
        guard let destinationController = getVideoController?() else { return .empty() }
        destinationController.video = video
        
        controller.show(destinationController, sender: self)
        
        return .empty()
    }
    
}
