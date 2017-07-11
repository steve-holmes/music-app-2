//
//  CategoryDismissAnimationController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/17/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class CategoryDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning, CategoryAnimationOptions {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let fromView = transitionContext.view(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        
        let fromViewInitialFrame = transitionContext.initialFrame(for: fromViewController)
        
        let fromViewFinalFrame = scaleRect(CGRect(
            origin: CGPoint(x: 0, y: containerView.frame.size.height / 2),
            size: fromViewInitialFrame.size
        ), by: 0.1)
        
        let snapshot = fromViewController.view.snapshotView(afterScreenUpdates: true)!
        snapshot.frame = fromViewInitialFrame
        
        containerView.addSubview(snapshot)
        
        fromView.isHidden = true
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(
            withDuration: duration,
            animations: {
                snapshot.frame = fromViewFinalFrame
            },
            completion: { _ in
                let success = !transitionContext.transitionWasCancelled
                
                if success {
                    fromView.removeFromSuperview()
                }
                
                snapshot.removeFromSuperview()
                
                transitionContext.completeTransition(success)
            }
        )
    }
    
}
