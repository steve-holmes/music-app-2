//
//  MainService.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import NSObject_Rx

protocol MainService {
    
    var notification: MainNotification { get }
    var coordinator: MainCoordinator { get }
    
    // MARK: Notification
    
    func play() -> Observable<Void>
    
    func onDidPlay() -> Observable<Void>
    func onDidPause() -> Observable<Void>
    
    func onDidGetTrack() -> Observable<Track>
    
    // MARK: Coordinator
    
    @discardableResult
    func `switch`(to: MainState) -> Observable<Void>
    @discardableResult
    func presentPlayer() -> Observable<Void>
    @discardableResult
    func setPresentPlayerModuleInteractively() -> Observable<Void>
    
}

class MAMainService: NSObject, MainService {
    
    let notification: MainNotification
    let coordinator: MainCoordinator
    
    init(notification: MainNotification, coordinator: MainCoordinator) {
        self.notification = notification
        self.coordinator = coordinator
        
        super.init()
        
        notification.onDidPlay()
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.setPresentPlayerModuleInteractively()
            })
            .addDisposableTo(rx_disposeBag)
        
        notification.onWillPreparePlaying()
            .subscribe(onNext: { _ in
                LoadingActivityIndicatorView.startLoading()
            })
            .addDisposableTo(rx_disposeBag)
        
        notification.onDidPreparePlaying()
            .subscribe(onNext: { [weak self] _ in
                LoadingActivityIndicatorView.stopLoading()
                self?.presentPlayer()
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    // MARK: Notification
    
    func play() -> Observable<Void> {
        return notification.play()
    }
    
    func onDidPlay() -> Observable<Void> {
        return notification.onDidPlay()
    }
    
    func onDidPause() -> Observable<Void> {
        return notification.onDidPause()
    }
    
    func onDidGetTrack() -> Observable<Track> {
        return notification.onDidGetTrack()
    }
    
    // MARK: Coordinator
    
    @discardableResult
    func `switch`(to state: MainState) -> Observable<Void> {
        return coordinator.switch(to: state)
    }
    
    @discardableResult
    func presentPlayer() -> Observable<Void> {
        return coordinator.presentPlayer()
    }
    
    @discardableResult
    func setPresentPlayerModuleInteractively() -> Observable<Void> {
        return coordinator.setPresentPlayerInteractively()
    }
    
}
