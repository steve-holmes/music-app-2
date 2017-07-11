//
//  MainAction.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import RxSwift
import Action
import NSObject_Rx

protocol MainAction {
    
    var store: MainStore { get }
    
    var onMenuItemTap: Action<MainState, Void> { get }
    var onImageTap: CocoaAction { get }
    var onChildTranslation: Action<CGFloat, Void> { get }
    
}

class MAMainAction: NSObject, MainAction {
    
    let store: MainStore
    let service: MainService
    
    init(store: MainStore, service: MainService) {
        self.store = store
        self.service = service
        
        super.init()
        
        self.service.onDidPlay()
            .subscribe(onNext: { [weak self] in
                self?.store.iconVisible.value = false
                self?.store.rotating.value = true
            })
            .addDisposableTo(rx_disposeBag)
        
        self.service.onDidPause()
            .subscribe(onNext: { [weak self] in
                self?.store.iconVisible.value = true
                self?.store.rotating.value = false
            })
            .addDisposableTo(rx_disposeBag)
        
        self.service.onDidGetTrack()
            .subscribe(onNext: { [weak self] track in
                self?.store.image.value = track.avatar
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    lazy var onMenuItemTap: Action<MainState, Void> = {
        return Action { [weak self] state in
            self?.store.position.value = state
            return self?.service.switch(to: state) ?? .empty()
        }
    }()
    
    lazy var onImageTap: CocoaAction = {
        return CocoaAction { [weak self] in
            return self?.service.play() ?? .empty()
        }
    }()
    
    lazy var onChildTranslation: Action<CGFloat, Void> = {
        return Action { [weak self] translation in
            self?.store.translation.value = translation
            return .empty()
        }
    }()
    
}
