//
//  PlayerTimerCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/26/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift

protocol PlayerTimerCoordinator {
    
    func presentTimer(in controller: UIViewController, time: Int?) -> Observable<Int?>
    
}

class MAPlayerTimerCoordinator: NSObject, PlayerTimerCoordinator {
    
    func presentTimer(in controller: UIViewController, time: Int?) -> Observable<Int?> {
        let destinationController = UIStoryboard.player.controller(of: PlayerTimerViewController.self)
        let timeObservable = destinationController.timeOutput
        
        if let time = time {
            destinationController.currentTime = time
            destinationController.timerEnabled = true
        }
        
        destinationController.transitioningDelegate = self
        destinationController.modalPresentationStyle = .custom
        
        controller.present(destinationController, animated: true, completion: nil)
        
        return timeObservable
    }
    
}

extension MAPlayerTimerCoordinator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PlayerTimerPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
