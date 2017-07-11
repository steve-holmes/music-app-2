//
//  SongContextPresentationController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/19/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class SongContextPresentationController: UIPresentationController {
    
    private let dimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmingView.alpha = 0
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        return dimmingView
    }()
    
    override func presentationTransitionWillBegin() {
        containerView!.insertSubview(dimmingView, belowSubview: presentedView!)
        
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: containerView!.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor)
        ])
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: nil)
    }
    
}
