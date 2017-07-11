//
//  TopicDetailCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

protocol TopicDetailCoordinator {
    
    func presentPlaylistDetail(_ playlist: Playlist, index: Int, in controller: UIViewController) -> Observable<Void>
    func registerPlaylistPreview(in view: UIView, controller: UIViewController) -> Observable<Void>
    
    func removePlaylistDetailInfos()
    
}

class MATopicDetailCoordinator: NSObject, TopicDetailCoordinator {
    
    // MARK: Coordinator
    
    weak var sourceViewController: TopicDetailViewController!
    var getDestinationViewController: (() -> PlaylistDetailViewController)!
    
    func presentPlaylistDetail(_ playlist: Playlist, index: Int, in controller: UIViewController) -> Observable<Void> {
        let destinationViewController = getDestinationViewController(playlist, page: index)
        controller.show(destinationViewController, sender: nil)
        return .empty()
    }
    
    func registerPlaylistPreview(in view: UIView, controller: UIViewController) -> Observable<Void> {
        if controller.traitCollection.forceTouchCapability != .unavailable {
            controller.registerForPreviewing(with: self, sourceView: view)
            sourceViewController = controller as? TopicDetailViewController
        }
        return .empty()
    }
    
    // MARK: Controller + Caching
    
    private let cache = ItemCache<PlaylistDetailInfo>()
    
    fileprivate func getDestinationViewController(_ playlist: Playlist, page: Int) -> PlaylistDetailViewController {
        let destinationVC = getDestinationViewController()
        destinationVC.playlist = playlist
        
        destinationVC.playlistDetailInfoOutput
            .subscribe(onNext: { [weak self] info in
                self?.cache.setItem(info, for: "page\(page)")
            })
            .addDisposableTo(rx_disposeBag)
        
        destinationVC.playlistDetailInfoInput = cache.getItem("page\(page)")
        
        return destinationVC
    }
    
    func removePlaylistDetailInfos() {
        cache.removeAllItems()
    }
    
}

// MARK: View Controller Transitioning

extension MATopicDetailCoordinator: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let cell = sourceViewController.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? PlaylistCell else { return nil }
        
        let location = cell.collectionView.convert(location, from: previewingContext.sourceView)
        
        guard let indexPath = cell.collectionView.indexPathForItem(at: location) else { return nil }
        
        let playlistIndex = indexPath.row
        let playlist = sourceViewController.store.playlists.value[playlistIndex]
        
        let destinationViewController = getDestinationViewController(
            playlist,
            page: playlistIndex
        )
        
        return destinationViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        sourceViewController?.show(viewControllerToCommit, sender: nil)
    }
    
}
