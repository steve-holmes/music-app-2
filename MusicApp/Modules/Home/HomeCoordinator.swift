//
//  HomeCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/1/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift

protocol HomeCoordinator {
    
    func presentPlaylist(_ playlist: Playlist) -> Observable<Void>
    func presentVideo(_ video: Video) -> Observable<Void>
    func presentTopic(_ topic: Topic) -> Observable<Void>
    
    func openContextMenu(_ song: Song) -> Observable<Void>
    
}

class MAHomeCoordinator: NSObject, HomeCoordinator {
    
    weak var sourceController: HomeViewController?
    var getPlaylistController: (() -> PlaylistDetailViewController?)?
    var getVideoController: (() -> VideoDetailViewController?)?
    var getTopicController: (() -> TopicDetailViewController?)?
    
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
    
    func presentTopic(_ topic: Topic) -> Observable<Void> {
        guard let sourceController = sourceController else { return .empty() }
        guard let destinationController = getTopicController?() else { return .empty() }
        
        destinationController.topic = topic
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

extension MAHomeCoordinator: UIViewControllerTransitioningDelegate {
    
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
