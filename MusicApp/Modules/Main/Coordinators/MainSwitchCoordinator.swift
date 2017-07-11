//
//  MainSwitchCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/10/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift

protocol MainSwitchCoordinator {
    
    @discardableResult
    func `switch`(to position: MainSwitchCoordinatorPosition, animated: Bool) -> Observable<Void>
    
}

class MAMainSwitchCoordinator: MainSwitchCoordinator {
    
    private weak var mainViewController: MainViewController?
    private var childViewControllers: [UIViewController]?
    
    func setMainViewController(_ main: MainViewController) {
        self.mainViewController = main
        self.childViewControllers = main.childViewControllers
    }
    
    @discardableResult
    func `switch`(to position: MainSwitchCoordinatorPosition, animated: Bool) -> Observable<Void> {
        switch position {
        case .left:     return switchToFirstController(animated: animated)
        case .right:    return switchToSecondController(animated: animated)
        }
    }
    
    @discardableResult
    func switchToFirstController(animated: Bool) -> Observable<Void> {
        if animated {
            return switchSmoothToController(at: 0)
        } else {
            return switchToController(at: 0)
        }
    }
    
    @discardableResult
    func switchToSecondController(animated: Bool) -> Observable<Void>{
        if animated {
            return switchSmoothToController(at: 1)
        } else {
            return switchToController(at: 1)
        }
    }
    
    @discardableResult
    private func switchToController(at index: Int) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        
        guard let containerView = mainViewController?.containerView,
              let childView = childViewControllers?[index].view else { return .empty() }
        
        containerView.removeAllSubviews()
        childView.frame = containerView.bounds
        containerView.addSubview(childView)
        
        subject.onCompleted()
        
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
    @discardableResult
    private func switchSmoothToController(at index: Int) -> Observable<Void> {
        let subject = PublishSubject<Void>()
        
        guard let containerView = mainViewController?.containerView,
              let firstView = childViewControllers?[0].view,
              let secondView = childViewControllers?[1].view else { return .empty() }
        
        containerView.removeAllSubviews()
        
        let duration: TimeInterval = 0.25
        let startAlpha: Float = 0
        let endAlpha: Float = 1
        let offset: CGFloat = containerView.bounds.size.width / 2
        
        // switch from left to right
        if index == 0 {
            firstView.layer.opacity = startAlpha
            firstView.layer.transform = CATransform3DMakeTranslation(-offset, 0, 0)
            firstView.frameEqual(with: containerView, originX: -offset)
            
            secondView.layer.opacity = endAlpha
            secondView.layer.transform = CATransform3DIdentity
            secondView.frameEqual(with: containerView)
            
            containerView.addSubview(firstView)
            containerView.addSubview(secondView)
            
            UIView.animate(
                withDuration: duration,
                animations: {
                    firstView.layer.opacity = endAlpha
                    firstView.layer.transform = CATransform3DIdentity
                    
                    secondView.layer.opacity = startAlpha
                    secondView.layer.transform = CATransform3DMakeTranslation(offset, 0, 0)
            }, completion: { _ in
                secondView.removeFromSuperview()
                subject.onCompleted()
            }
            )
        }
        
        // switch from right to left
        if index == 1 {
            firstView.layer.opacity = endAlpha
            firstView.layer.transform = CATransform3DIdentity
            firstView.frameEqual(with: containerView)
            
            secondView.layer.opacity = startAlpha
            secondView.layer.transform = CATransform3DMakeTranslation(offset, 0, 0)
            secondView.frameEqual(with: containerView, originX: offset)
            
            containerView.addSubview(firstView)
            containerView.addSubview(secondView)
            
            UIView.animate(
                withDuration: duration,
                animations: {
                    firstView.layer.opacity = startAlpha
                    firstView.layer.transform = CATransform3DMakeTranslation(-offset, 0, 0)
                    
                    secondView.layer.opacity = endAlpha
                    secondView.layer.transform = CATransform3DIdentity
            }, completion: { _ in
                firstView.removeFromSuperview()
                subject.onCompleted()
            }
            )
        }
        
        return subject.asObservable()
            .take(1)
            .ignoreElements()
    }
    
}
