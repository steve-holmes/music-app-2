//
//  SearchCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/12/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol SearchCoordinator {
    
    func presentPlaylist(_ playlist: Playlist) -> Observable<Void>
    func presentVideo(_ video: Video) -> Observable<Void>
    
    func openContextMenu(_ song: Song) -> Observable<Void>
    
}

class MASearchCoordinator: NSObject, SearchCoordinator {
    
    weak var sourceController: SearchViewController?
    
    var getPlaylistController: (() -> PlaylistDetailViewController?)?
    var getVideoController: (() -> VideoDetailViewController?)?
    
    
    func presentPlaylist(_ playlist: Playlist) -> Observable<Void> {
        guard let sourceController = sourceController else { return .empty() }
        guard let destinationController = getPlaylistController?() else { return .empty() }
        
        destinationController.playlist = playlist
        sourceController.show(destinationController, sender: nil)
        
        return .empty()
    }
    
    func presentVideo(_ video: Video) -> Observable<Void> {
        guard let sourceController = sourceController else { return .empty() }
        guard let destinationController = getVideoController?() else { return .empty() }
        
        destinationController.video = video
        sourceController.show(destinationController, sender: nil)
        
        return .empty()
    }
    
    func openContextMenu(_ song: Song) -> Observable<Void> {
        guard let sourceController = sourceController else { return .empty() }
        let controller = UIStoryboard.song.controller(of: SongContextMenuViewController.self)
        
        controller.song = song
        
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        
        sourceController.present(controller, animated: true, completion: nil)
        
        return .empty()
    }
    
}

extension MASearchCoordinator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SongContextPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
