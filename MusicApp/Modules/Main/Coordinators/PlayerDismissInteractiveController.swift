//
//  MainCoordinator+Modal+Dismiss+Interactive.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 5/27/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class PlayerDismissInteractiveController: NSObject, UIViewControllerInteractiveTransitioning, PlayerAnimationOptions {
    
    // MARK: Properties
    
    var interactionInProgress = false
    fileprivate var shouldCompleteTransition = false
    
    fileprivate weak var viewController: UIViewController!
    fileprivate weak var containerView: UIView!
    fileprivate weak var view: UIView!
    
    fileprivate weak var borderView: UIView!
    fileprivate weak var imageView: UIView!
    
    fileprivate lazy var centerBottomDistance: CGFloat = {
        return self.containerView.frame.height + self.bottomDistance - self.borderView.frame.height / 2
    }()
    
    fileprivate var transitionContext: UIViewControllerContextTransitioning!
    
    // MARK: Start Transitioning
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
    }
    
    // MARK: Configuration
    
    func configure(viewController: PlayerViewController, presentingController: MainViewController) {
        self.viewController = viewController
        view = viewController.view
        containerView = viewController.view.superview
        
        imageView = presentingController.imageView
        borderView = presentingController.borderView
        
        preparePanGestureRecoginzer(in: viewController.view)
    }
    
    private func preparePanGestureRecoginzer(in view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerDidReceive(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
}

// MARK: Pan Gesture Handler

extension PlayerDismissInteractiveController {
    
    func panGestureRecognizerDidReceive(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            onBegan(panGesture)
        case .changed:
            onChanged(panGesture)
        case .cancelled, .failed:
            onCancelled(panGesture)
        case .ended:
            onEnded(panGesture)
        default:
            break
        }
    }
    
    private func onBegan(_ panGesture: UIPanGestureRecognizer) {
        panGesture.setTranslation(.zero, in: containerView)
        interactionInProgress = true
        viewController.dismiss(animated: true)
    }
    
    private func onChanged(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: containerView)
        let height: CGFloat = containerView.frame.size.height
        let progress = translation.y / height
        
        if progress < 0 { return }
        
        shouldCompleteTransition = progress > 0.5
        
        update(progress)
    }
    
    private func onCancelled(_ panGesture: UIPanGestureRecognizer) {
        interactionInProgress = false
        cancel()
    }
    
    private func onEnded(_ panGesture: UIPanGestureRecognizer) {
        interactionInProgress = false
        
        if shouldCompleteTransition {
            finish()
        } else {
            cancel()
        }
    }
    
}

// MARK: Completion Animation

extension PlayerDismissInteractiveController {
    
    func update(_ percentComplete: CGFloat) {
        let offset = percentComplete * containerView.frame.height
        
        view.frame.origin.y = offset
        view.alpha = endAlpha - percentComplete * (endAlpha - startAlpha)
        
        if offset < centerBottomDistance {
            borderView.center.y = offset
            borderView.alpha = endAlpha - view.alpha
            
            // imageContainer.center.y = centerBottomDistance + (containerView.frame.height - (offset + (containerView.frame.height - centerBottomDistance)))
            imageView.center.y = centerBottomDistance * 2 - offset
        } else {
            borderView.center.y = centerBottomDistance
            borderView.alpha = self.endAlpha
            
            imageView.center.y = centerBottomDistance
        }
        
    }
    
    func finish() {
        UIView.animate(
            withDuration: duration,
            animations: {
                self.view.frame.origin.y = self.containerView.frame.height
                self.view.alpha = self.startAlpha
                
                self.borderView.center.y = self.centerBottomDistance
                self.borderView.alpha = self.endAlpha
                
                self.imageView.center.y = self.centerBottomDistance
            },
            completion: { _ in
                self.view.removeFromSuperview()
                
                let success = !self.transitionContext.transitionWasCancelled
                self.transitionContext.completeTransition(success)
            }
        )
    }
    
    func cancel() {
        UIView.animate(
            withDuration: duration,
            animations: { 
                self.view.frame.origin.y = 0
                self.view.alpha = self.endAlpha
                
                self.borderView.center.y = 0
                self.borderView.alpha = self.startAlpha
                
                // offset = 0
                self.imageView.center.y = self.centerBottomDistance * 2
            },
            completion: { _ in
                self.transitionContext.completeTransition(false)
            }
        )
    }
    
}
