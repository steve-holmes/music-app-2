//
//  TopicCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift

protocol TopicCoordinator {
    
    func presentTopicDetail(_ topic: Topic, index: Int) -> Observable<Void>
    func registerTopicPreview(in view: UIView) -> Observable<Void>
    
    func removeTopicDetailInfos()
    
}

class MATopicCoordinator: NSObject, TopicCoordinator {
    
    // MARK: Coordinator
    
    weak var sourceViewController: TopicViewController!
    var getDestinationViewController: (() -> TopicDetailViewController)!
    
    func presentTopicDetail(_ topic: Topic, index: Int) -> Observable<Void> {
        let destinationViewController = getDestinationViewController(topic, page: index)
        sourceViewController?.show(destinationViewController, sender: nil)
        return .empty()
    }
    
    func registerTopicPreview(in view: UIView) -> Observable<Void> {
        if sourceViewController.traitCollection.forceTouchCapability != .unavailable {
            sourceViewController.registerForPreviewing(with: self, sourceView: view)
        }
        return .empty()
    }
    
    // MARK: Controller + Caching
    
    private let cache = ItemCache<TopicDetailInfo>()
    
    fileprivate func getDestinationViewController(_ topic: Topic, page: Int) -> TopicDetailViewController {
        let destinationVC = getDestinationViewController()
        destinationVC.topic = topic
        
        destinationVC.topicDetailInfoOutput
            .subscribe(onNext: { [weak self] info in
                self?.cache.setItem(info, for: "page\(page)")
            })
            .addDisposableTo(rx_disposeBag)
        
        destinationVC.topicDetailInfoInput = cache.getItem("page\(page)")
        
        return destinationVC
    }
    
    func removeTopicDetailInfos() {
        cache.removeAllItems()
    }
    
}

// MARK: View Controller Transitioning

extension MATopicCoordinator: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let location = sourceViewController.tableView.convert(location, from: previewingContext.sourceView)
        
        guard let indexPath = sourceViewController.tableView.indexPathForRow(at: location) else { return nil }
        
        let topicIndex = indexPath.row
        let topic = sourceViewController.store.topics.value[topicIndex]
        
        let destinationViewController = getDestinationViewController(
            topic,
            page: topicIndex
        )
        
        return destinationViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        sourceViewController?.show(viewControllerToCommit, sender: nil)
    }
    
}
