//
//  RankCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift

protocol RankCoordinator {
    
    func presentSong(country: String) -> Observable<Void>
    func presentPlaylist(_ playlists: [Playlist], country: String) -> Observable<Void>
    func presentVideo(_ videos: [Video], country: String) -> Observable<Void>
    
}

class MARankCoordinator: RankCoordinator {
    
    weak var sourceViewController: RankViewController?
    
    var getSongController: (() -> RankSongViewController?)?
    var getPlaylistController: (() -> RankPlaylistViewController?)?
    var getVideoController: (() -> RankVideoViewController?)?
    
    func presentSong(country: String) -> Observable<Void> {
        guard let sourceController = sourceViewController else { return .empty() }
        guard let destinationController = getSongController?() else { return .empty() }
        
        destinationController.country = country
        
        sourceController.show(destinationController, sender: nil)
        
        return .empty()
    }
    
    func presentPlaylist(_ playlists: [Playlist], country: String) -> Observable<Void> {
        guard let sourceController = sourceViewController else { return .empty() }
        guard let destinationController = getPlaylistController?() else { return .empty() }
        
        destinationController.playlists = playlists
        destinationController.country = country
        
        sourceController.show(destinationController, sender: self)
        
        return .empty()
    }
    
    func presentVideo(_ videos: [Video], country: String) -> Observable<Void> {
        guard let sourceController = sourceViewController else { return .empty() }
        guard let destinationController = getVideoController?() else { return .empty() }
        
        destinationController.videos = videos
        destinationController.country = country
        
        sourceController.show(destinationController, sender: self)
        
        return .empty()
    }
    
}
