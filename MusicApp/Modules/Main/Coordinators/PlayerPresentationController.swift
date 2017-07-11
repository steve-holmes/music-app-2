//
//  ManCoordinator+Modal+Presentation.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 5/27/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class PlayerPresentationController: UIPresentationController, PlayerAnimationOptions {
    
    override func presentationTransitionWillBegin() {
        guard let mainViewController = presentingViewController as? MainViewController else { return }
        
        guard let imageView = mainViewController.imageView,
            let borderView = mainViewController.borderView else { return }
        
        let center = CGPoint(x: mainViewController.view.frame.size.width / 2, y: 0)
        let centerBottomDistance = mainViewController.view.frame.height + bottomDistance - borderView.frame.height / 2
        
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else { return }
        
        borderView.alpha = endAlpha
        
        transitionCoordinator.animate(
            alongsideTransition: { _ in
                borderView.center = center
                borderView.alpha = self.startAlpha
                
                imageView.center = CGPoint(x: center.x, y: centerBottomDistance * 2)
            },
            completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let mainViewController = presentingViewController as? MainViewController else { return }
        
        guard let imageView = mainViewController.imageView,
            let borderView = mainViewController.borderView else { return }
        
        let center = CGPoint(
            x: mainViewController.view.frame.size.width / 2,
            y: mainViewController.view.frame.size.height - borderView.frame.size.height / 2 + bottomDistance
        )
        
        guard let transitionCoordinator = presentedViewController.transitionCoordinator else { return }
        
        borderView.alpha = startAlpha
        
        transitionCoordinator.animate(
            alongsideTransition: { _ in
                borderView.center = center
                borderView.alpha = self.endAlpha
                
                imageView.center = center
                imageView.alpha = self.endAlpha
            },
            completion: nil
        )
    }
    
}
