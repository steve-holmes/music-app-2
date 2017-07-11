//
//  SingerCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/21/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

protocol SingerCoordinator {
    
    func presentSingerDetail(_ singer: Singer, category: String, index: Int) -> Observable<Void>
    func registerSingerPreview(in view: UIView) -> Observable<Void>
    
    func removeSingerDetailInfos(category: String)
    
}

class MASingerCoordinator: NSObject, SingerCoordinator {
    
    // MARK: Coordinator
    
    weak var sourceViewController: SingerViewController!
    var getDestinationViewController: (() -> SingerDetailViewController)!
    
    func presentSingerDetail(_ singer: Singer, category: String, index: Int) -> Observable<Void> {
        let destinationViewController = getDestinationViewController(singer, category: category, page: index)
        sourceViewController?.show(destinationViewController, sender: nil)
        return .empty()
    }
    
    func registerSingerPreview(in view: UIView) -> Observable<Void> {
        if sourceViewController.traitCollection.forceTouchCapability != .unavailable {
            sourceViewController.registerForPreviewing(with: self, sourceView: view)
        }
        return .empty()
    }
    
    // MARK: Controller + Caching
    
    private let cache = CategoryCache<SingerDetailInfo>()
    
    fileprivate func getDestinationViewController(_ singer: Singer, category: String, page: Int) -> SingerDetailViewController {
        let destinationVC = getDestinationViewController()
        destinationVC.singer = singer
        
        destinationVC.singerDetailInfoOutput
            .subscribe(onNext: { [weak self] info in
                self?.cache.setItem(info, category: category, page: page)
            })
            .addDisposableTo(rx_disposeBag)
        
        destinationVC.singerDetailInfoInput = cache.getItem(category: category, page: page)
        
        return destinationVC
    }
    
    func removeSingerDetailInfos(category: String) {
        cache.removeItems(category: category)
    }
    
}

// MARK: View Controller Transitioning

extension MASingerCoordinator: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let cell = sourceViewController.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? SingerCell else { return nil }
        
        let location = cell.collectionView.convert(location, from: previewingContext.sourceView)
        
        guard let indexPath = cell.collectionView.indexPathForItem(at: location) else { return nil }
        
        let singerIndex = indexPath.row
        let singer = sourceViewController.store.singers.value[singerIndex]
        
        let destinationViewController = getDestinationViewController(
            singer,
            category: sourceViewController.store.category.value.link,
            page: singerIndex
        )
        
        return destinationViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        sourceViewController?.show(viewControllerToCommit, sender: nil)
    }
    
}
