//
//  RankSongCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift

protocol RankSongCoordinator {
    
    func openContextMenu(_ song: Song, in controller: UIViewController) -> Observable<Void>
    
}

class MARankSongCoordinator: NSObject, RankSongCoordinator {
    
    func openContextMenu(_ song: Song, in controller: UIViewController) -> Observable<Void> {
        let sourceController = controller
        let controller = UIStoryboard.song.controller(of: SongContextMenuViewController.self)
        
        controller.song = song
        
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        
        sourceController.present(controller, animated: true, completion: nil)
        
        return .empty()
    }
    
}

extension MARankSongCoordinator: UIViewControllerTransitioningDelegate {
    
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
