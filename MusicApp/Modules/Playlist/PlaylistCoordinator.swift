//
//  PlaylistCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

protocol PlaylistCoordinator {
    
    func presentPlaylistDetail(_ playlist: Playlist, category: String, index: Int) -> Observable<Void>
    func registerPlaylistPreview(in view: UIView) -> Observable<Void>
    
    func removePlaylistDetailInfos(category: String)

}

class MAPlaylistCoordinator: NSObject, PlaylistCoordinator {
    
    // MARK: Coordinator
    
    weak var sourceViewController: PlaylistViewController!
    var getDestinationViewController: (() -> PlaylistDetailViewController)!

    func presentPlaylistDetail(_ playlist: Playlist, category: String, index: Int) -> Observable<Void> {
        let destinationViewController = getDestinationViewController(playlist, category: category, page: index)
        sourceViewController?.show(destinationViewController, sender: nil)
        return .empty()
    }
    
    func registerPlaylistPreview(in view: UIView) -> Observable<Void> {
        if sourceViewController.traitCollection.forceTouchCapability != .unavailable {
            sourceViewController.registerForPreviewing(with: self, sourceView: view)
        }
        return .empty()
    }
    
    // MARK: Controller + Caching
    
    private let cache = CategoryCache<PlaylistDetailInfo>()
    
    fileprivate func getDestinationViewController(_ playlist: Playlist, category: String, page: Int) -> PlaylistDetailViewController {
        let destinationVC = getDestinationViewController()
        destinationVC.playlist = playlist
        
        destinationVC.playlistDetailInfoOutput
            .subscribe(onNext: { [weak self] info in
                self?.cache.setItem(info, category: category, page: page)
            })
            .addDisposableTo(rx_disposeBag)
        
        destinationVC.playlistDetailInfoInput = cache.getItem(category: category, page: page)
        
        return destinationVC
    }
    
    func removePlaylistDetailInfos(category: String) {
        cache.removeItems(category: category)
    }
    
}

// MARK: View Controller Transitioning

extension MAPlaylistCoordinator: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let cell = sourceViewController.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? PlaylistCell else { return nil }
        
        let location = cell.collectionView.convert(location, from: previewingContext.sourceView)
        
        guard let indexPath = cell.collectionView.indexPathForItem(at: location) else { return nil }
        
        let playlistIndex = indexPath.row
        let playlist = sourceViewController.store.playlists.value[playlistIndex]
        
        let destinationViewController = getDestinationViewController(
            playlist,
            category: sourceViewController.store.category.value.link,
            page: playlistIndex
        )
        
        return destinationViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        sourceViewController?.show(viewControllerToCommit, sender: nil)
    }
    
}
