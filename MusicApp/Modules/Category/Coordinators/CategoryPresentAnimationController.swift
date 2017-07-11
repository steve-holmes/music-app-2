//
//  CategoryPresentAnimationController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/17/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class CategoryPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning, CategoryAnimationOptions {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        
        let toViewInitialFrame = scaleRect(CGRect(
            origin: CGPoint(x: 0, y: containerView.frame.size.height / 2),
            size: toViewFinalFrame.size
        ), by: 0.1)
        
        let snapshot = toViewController.view.snapshotView(afterScreenUpdates: true)!
        snapshot.frame = toViewInitialFrame
        
        containerView.addSubview(toView)
        containerView.addSubview(snapshot)
        
        toView.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: springDamping,
            initialSpringVelocity: initialVelocity,
            options: [],
            animations: {
                snapshot.frame = toViewFinalFrame
            },
            completion: { _ in
                let success = !transitionContext.transitionWasCancelled
                
                if !success {
                    toView.removeFromSuperview()
                }
                
                toView.isHidden = false
                snapshot.removeFromSuperview()
                
                transitionContext.completeTransition(success)
            }
        )
    }
    
}
