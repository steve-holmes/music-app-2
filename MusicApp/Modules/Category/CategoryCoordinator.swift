//
//  CategoryCoordinator.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/17/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

protocol CategoryCoordinator {
    
    var presentingViewController: UIViewController? { get set }
    
    var subKindVisible: Bool { get set }
    
    func presentCategories(category: CategoryInfo, infos: [CategoriesInfo], completion: @escaping (CategoryInfo?) -> Void)
    
}

class MACategoryCoordinator: NSObject, CategoryCoordinator {
    
    weak var presentingViewController: UIViewController?
    
    var subKindVisible: Bool = true
    
    func presentCategories(category: CategoryInfo, infos: [CategoriesInfo], completion: @escaping (CategoryInfo?) -> Void) {
        guard let presentingViewController = self.presentingViewController else {
            completion(nil)
            return
        }
        
        let controller = UIStoryboard.category.controller(of: CategoryViewController.self)
        
        controller.category = category
        controller.categoryInfos = infos
        controller.suffixSegmentControlHiddenEnabled = !subKindVisible
        controller.categoryCompletion = completion
        
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        
        presentingViewController.present(controller, animated: true)
    }
    
}

extension MACategoryCoordinator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CategoryPresentAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CategoryDismissAnimationController()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CategoryPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
