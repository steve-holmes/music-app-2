//
//  SongCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/13/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift

protocol SongCoordinator {
    
    @discardableResult
    func openContextMenu(_ song: Song, in controller: UIViewController) -> Observable<Void>
    
}

class MASongCoordinator: NSObject, SongCoordinator {
    
    @discardableResult
    func openContextMenu(_ song: Song, in controller: UIViewController) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        
        let presentingViewController = controller
        let controller = UIStoryboard.song.controller(of: SongContextMenuViewController.self)
        
        controller.song = song
        
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        
        presentingViewController.present(controller, animated: true) { 
            subject.onNext()
        }
        
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
}

extension MASongCoordinator: UIViewControllerTransitioningDelegate {
    
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
