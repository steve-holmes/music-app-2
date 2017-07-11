//
//  PlayerTimerPresentationController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/26/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import NSObject_Rx

class PlayerTimerPresentationController: UIPresentationController {
    
    private var dimmingView: UIView!
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        configureDimmingView()
    }
    
    private func configureDimmingView() {
        dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.isHidden = true
        dimmingView.alpha = 0
        
        dimmingView.rx.tapGesture()
            .subscribe(onNext: { [weak self] _ in
                self?.presentingViewController.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(rx_disposeBag)
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        let containerSize = containerView!.bounds.size
        let size = CGSize(width: containerSize.width - 20, height: containerSize.height / 3)
        let origin = CGPoint(x: 10, y: containerSize.height - (10 + size.height))
        return CGRect(origin: origin, size: size)
    }
    
    override var presentedView: UIView? {
        let presentedView = presentedViewController.view
        presentedView?.clipsToBounds = true
        presentedView?.layer.cornerRadius = 10
        return presentedView
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        containerView.insertSubview(dimmingView, belowSubview: presentedViewController.view)
        
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        dimmingView.isHidden = false
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        dimmingView.isHidden = false
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0
            dimmingView.isHidden = true
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }) { _ in
            self.dimmingView.isHidden = true
            self.dimmingView.removeFromSuperview()
        }
    }
    
}
