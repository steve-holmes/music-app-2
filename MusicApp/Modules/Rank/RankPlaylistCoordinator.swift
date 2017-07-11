//
//  RankPlaylistCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/30/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

protocol RankPlaylistCoordinator {
    
    func presentPlaylist(_ playlist: Playlist, index: Int, in controller: UIViewController) -> Observable<Void>
    func registerPlaylistPreview(_ sourceView: UIView, in controller: UIViewController) -> Observable<Void>
    
    func removePlaylistDetailInfos()
    
}

class MARankPlaylistCoordinator: NSObject, RankPlaylistCoordinator {
    
    weak var sourceController: RankPlaylistViewController?
    var getDestinationController: (() -> PlaylistDetailViewController?)?
    
    let cache = ItemCache<PlaylistDetailInfo>()
    
    func presentPlaylist(_ playlist: Playlist, index: Int, in controller: UIViewController) -> Observable<Void> {
        guard let destinationController = getDestinationController(playlist, index: index) else { return .empty() }
        controller.show(destinationController, sender: nil)
        return .empty()
    }
    
    func registerPlaylistPreview(_ sourceView: UIView, in controller: UIViewController) -> Observable<Void> {
        if controller.traitCollection.forceTouchCapability != .unavailable {
            controller.registerForPreviewing(with: self, sourceView: sourceView)
            sourceController = controller as? RankPlaylistViewController
        }
        return .empty()
    }
    
    fileprivate func getDestinationController(_ playlist: Playlist, index: Int) -> PlaylistDetailViewController? {
        guard let destinationController = getDestinationController?() else { return nil }
        destinationController.playlist = playlist
        
        destinationController.playlistDetailInfoOutput
            .subscribe(onNext: { [weak self] info in
                self?.cache.setItem(info, for: "page\(index)")
            })
            .addDisposableTo(rx_disposeBag)
        
        destinationController.playlistDetailInfoInput = cache.getItem("page\(index)")
        
        return destinationController
    }
    
    func removePlaylistDetailInfos() {
        cache.removeAllItems()
    }
    
    deinit {
        removePlaylistDetailInfos()
    }
    
}

extension MARankPlaylistCoordinator: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let sourceController = sourceController else { return nil }
        
        let location = sourceController.tableView.convert(location, from: previewingContext.sourceView)
        guard let indexPath = sourceController.tableView.indexPathForRow(at: location) else { return nil }
        
        let playlistIndex = indexPath.row
        let playlist = sourceController.store.playlists.value[playlistIndex]
        
        guard let destinationController = getDestinationController(playlist, index: playlistIndex) else { return nil }
        
        return destinationController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        sourceController?.show(viewControllerToCommit, sender: self)
    }
    
}
