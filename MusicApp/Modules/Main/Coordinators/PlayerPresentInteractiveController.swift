//
//  MainCoordinator+Modal+Present+Interactive.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 5/27/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class PlayerPresentInteractiveController: NSObject, UIViewControllerInteractiveTransitioning, PlayerAnimationOptions {
    
    // MARK: Properties
    
    var interactionInProgress = false
    fileprivate var shouldCompleteTransition = false
    
    fileprivate var viewController: UIViewController!
    fileprivate weak var containerView: UIView!
    fileprivate var view: UIView!
    
    fileprivate weak var presentingViewController: UIViewController!
    fileprivate weak var imageView: UIView!
    fileprivate weak var borderView: UIView!
    
    fileprivate var completion: (() -> Void)!
    
    fileprivate lazy var centerBottomDistance: CGFloat = {
        return self.containerView.frame.height + self.bottomDistance - self.borderView.frame.height / 2
    }()
    
    fileprivate var transitionContext: UIViewControllerContextTransitioning!
    
    // MARK: Start Transitioning
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        containerView = transitionContext.containerView
        containerView.addSubview(view)
    }
    
    // MARK: Configuration
    
    func configure(viewController: UIViewController, parentViewController: UIViewController, completion: @escaping () -> Void) {
        self.viewController = viewController
        view = viewController.view
        
        presentingViewController = parentViewController
        
        let mainVC = parentViewController as! MainViewController
        imageView = mainVC.imageView
        borderView = mainVC.borderView

        self.completion = completion
        
        preparePanGestureRecoginzer(in: imageView)
    }
    
    private func preparePanGestureRecoginzer(in view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerDidReceive(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
}

// MARK: Pan Gesture Handler

extension PlayerPresentInteractiveController {
    
    func panGestureRecognizerDidReceive(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            onBegan(panGesture)
        case .changed:
            onChanged(panGesture)
        case .cancelled:
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
        presentingViewController.present(viewController, animated: true, completion: completion)
    }
    
    private func onChanged(_ panGesture: UIPanGestureRecognizer) {
        guard let containerView = containerView else { return }
        let translation = panGesture.translation(in: containerView)
        let height: CGFloat = containerView.frame.size.height
        let progress = (-translation.y) / height
        
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

extension PlayerPresentInteractiveController {
    
    func update(_ percentComplete: CGFloat) {
        let offset = (1 - percentComplete) * containerView.frame.height
        
        view.frame.origin.y = offset
        view.alpha = startAlpha + percentComplete * (endAlpha - startAlpha)
        
        if offset < centerBottomDistance {
            borderView.center.y = offset
            borderView.alpha = endAlpha - view.alpha
            
            imageView.center.y = centerBottomDistance * 2 - offset
        } else {
            borderView.center.y = centerBottomDistance
            borderView.alpha = self.endAlpha
            
            imageView.center.y = centerBottomDistance
        }
    }
    
    func cancel() {
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
                self.transitionContext.completeTransition(false)
            }
        )
    }
    
    func finish() {
        UIView.animate(
            withDuration: duration,
            animations: {
                self.view.frame.origin.y = 0
                self.view.alpha = self.endAlpha
                
                self.borderView.center.y = 0
                self.borderView.alpha = self.startAlpha
                
                self.imageView.center.y = self.centerBottomDistance * 2
            },
            completion: { _ in
                self.transitionContext.completeTransition(true)
            }
        )
    }
    
}
