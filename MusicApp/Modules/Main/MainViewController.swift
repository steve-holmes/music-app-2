//
//  MainViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx

class MainViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabbar: MainTabBarView!
    @IBOutlet weak var borderView: MainBorderView!
    @IBOutlet weak var imageView: MainImageView!

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindStore()
        bindAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configure()
    }
    
    // MARK: Configuration
    
    func configure() {
        let bottomDistance: CGFloat = 10
        let center = CGPoint(
            x: view.frame.size.width / 2,
            y: view.frame.size.height - borderView.frame.size.height / 2 + bottomDistance
        )
        
        tabbar.configure(store: store, action: action)
        borderView.configure(store: store, action: action, center: center)
        imageView.configure(store: store, action: action, center: center)
    }
    
    // MARK: Status Bar
    
    fileprivate var statusHidden = false
    
    override var prefersStatusBarHidden: Bool {
        return statusHidden
    }
    
    func setStatusBarHidden(_ hidden: Bool) {
        statusHidden = hidden
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: Store and Action
    
    var store: MainStore!
    var action: MainAction!
    
    private func bindStore() {
        store.position.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] state in
                self?.tabbar.setState(state)
            })
            .addDisposableTo(rx_disposeBag)
        
        store.image.asObservable()
            .subscribe(onNext: { [weak self] image in
                self?.imageView.backgroundImage = image
            })
            .addDisposableTo(rx_disposeBag)
        
        store.rotating.asObservable()
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] rotating in
                if rotating {
                    self?.imageView.startRotating()
                } else {
                    self?.imageView.stopRotating()
                }
            })
            .addDisposableTo(rx_disposeBag)
        
        store.iconVisible.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] visible in
                self?.imageView.visible = visible
            })
            .addDisposableTo(rx_disposeBag)
    }

}

extension MainViewController {
    
    func bindAction() {
        
    }
    
}
