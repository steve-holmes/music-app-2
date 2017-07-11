//
//  UIViewController+Container.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 5/26/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addController(_ controller: UIViewController, in view: UIView) {
        self.addChildViewController(controller)
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    func addController(_ controller: UIViewController) {
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: self)
    }
    
    func removeController(_ controller: UIViewController) {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
}
