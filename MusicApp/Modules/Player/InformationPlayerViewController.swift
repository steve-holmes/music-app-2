//
//  InformationPlayerViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/23/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class InformationPlayerViewController: UIViewController {

    @IBOutlet weak var avatarImageView: AnimatedCircleImageView!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    
    var store: PlayerStore!
    var action: PlayerAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.configure()
        
        bindStore()
        bindAction()
    }

}

// MARK: Store

extension InformationPlayerViewController {
    
    func bindStore() {
        store.track.asObservable()
            .map { track in track.avatar }
            .bind(to: avatarImageView.rx.image)
            .addDisposableTo(rx_disposeBag)
        
        store.track.asObservable()
            .subscribe(onNext: { [weak self] track in
                self?.songLabel.text = track.name
                self?.singerLabel.text = track.singer
            })
            .addDisposableTo(rx_disposeBag)
        
        store.playButtonState.asObservable()
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .playing:  self?.avatarImageView.startAnimating()
                case .paused:   self?.avatarImageView.stopAnimating()
                }
            })
            .addDisposableTo(rx_disposeBag)
    }
    
}

// MARK: Action

extension InformationPlayerViewController {
    
    func bindAction() {
        
    }
    
}
