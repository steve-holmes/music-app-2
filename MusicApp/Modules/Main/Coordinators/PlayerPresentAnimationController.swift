//
//  MainCoordinator+Modal+Present.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 5/27/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class PlayerPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning, PlayerAnimationOptions {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
            let toView = transitionContext.view(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        
        let toViewFinalFrame = transitionContext.finalFrame(for: toViewController)
        
        let toViewInitialFrame = CGRect(
            origin: CGPoint(x: 0, y: containerView.frame.size.height),
            size: toViewFinalFrame.size
        )
        
        containerView.addSubview(toView)
        
        toView.frame = toViewInitialFrame
        toView.alpha = startAlpha
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(
            withDuration: duration,
            animations: {
                toView.frame = toViewFinalFrame
                toView.alpha = self.endAlpha
            },
            completion: { _ in
                let success = !transitionContext.transitionWasCancelled
                
                if !success {
                    toView.removeFromSuperview()
                }
                
                transitionContext.completeTransition(success)
            }
        )
    }
    
}
