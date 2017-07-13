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
    func presentVideo(_ video: Video, in controller: UIViewController) -> Observable<Void>
    
}

class MASingerDetailCoordinator: SingerDetailCoordinator {
    
    var getPlaylistController: (() -> PlaylistDetailViewController?)?
    var getVideoController: (() -> VideoDetailViewController?)?
    
    func presentPlaylist(_ playlist: Playlist, in controller: UIViewController) -> Observable<Void> {
        guard let destinationVC = getPlaylistController?() else { return .empty() }
        destinationVC.playlist = playlist

        controller.show(destinationVC, sender: self)
        
        return .empty()
    }
    
    func presentVideo(_ video: Video, in controller: UIViewController) -> Observable<Void> {
        guard let destinationController = getVideoController?() else { return .empty() }
        destinationController.video = video
        
        controller.show(destinationController, sender: self)
        
        return .empty()
    }
    
}
