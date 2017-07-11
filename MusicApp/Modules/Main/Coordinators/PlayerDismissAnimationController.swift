//
//  MainCoordinator+Modal+Dismiss.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 5/27/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class PlayerDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning, PlayerAnimationOptions {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let fromView = transitionContext.view(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        
        let fromViewInitialFrame = transitionContext.initialFrame(for: fromViewController)
        
        let fromViewFinalFrame = CGRect(
            origin: CGPoint(x: 0, y: containerView.frame.size.height),
            size: fromViewInitialFrame.size
        )
        
        fromView.alpha = endAlpha
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(
            withDuration: duration,
            animations: {
                fromView.frame = fromViewFinalFrame
                fromView.alpha = self.startAlpha
            },
            completion: { _ in
                let success = !transitionContext.transitionWasCancelled
                
                if success {
                    fromView.removeFromSuperview()
                }
                
                transitionContext.completeTransition(success)
            }
        )
    }
    
}
