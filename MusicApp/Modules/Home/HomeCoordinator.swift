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
    
}

class MAHomeCoordinator: HomeCoordinator {
    
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
    
}
