//
//  SingerDetailCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/22/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift

protocol SingerDetailCoordinator {
 
    func presentPlaylist(_ playlist: Playlist, in controller: UIViewController) -> Observable<Void>
    
}

class MASingerDetailCoordinator: SingerDetailCoordinator {
    
    var getController: (() -> PlaylistDetailViewController?)?
    
    func presentPlaylist(_ playlist: Playlist, in controller: UIViewController) -> Observable<Void> {
        guard let destinationVC = getController?() else { return .empty() }
        destinationVC.playlist = playlist

        controller.show(destinationVC, sender: self)
        
        return .empty()
    }
    
}
