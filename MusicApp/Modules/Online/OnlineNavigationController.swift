//
//  OnlineNavigationController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/29/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class OnlineNavigationController: UINavigationController {
    
    fileprivate var popRecognizer: InteractivePopRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setInteractiveRecognizer()
    }
    
    private func setInteractiveRecognizer() {
        popRecognizer = InteractivePopRecognizer(controller: self)
        self.interactivePopGestureRecognizer?.delegate = popRecognizer
    }
    
    fileprivate var statusHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return statusHidden
    }
    
    func setStatusBarHidden(_ hidden: Bool) {
        statusHidden = hidden
        setNeedsStatusBarAppearanceUpdate()
    }

}

fileprivate class InteractivePopRecognizer: NSObject, UIGestureRecognizerDelegate {
    
    var navigationController: UINavigationController
    
    init(controller: UINavigationController) {
        self.navigationController = controller
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }
    
    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
