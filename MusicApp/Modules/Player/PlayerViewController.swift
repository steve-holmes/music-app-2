//
//  PlayerViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/9/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Action
import NSObject_Rx

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var containerView: PlayContainerView!
    @IBOutlet weak var alphaView: UIVisualEffectView!
    
    @IBOutlet weak var progressBar: PlayerProgressBar!
    
    @IBOutlet weak var playButton: PlayCenterView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    @IBOutlet weak var pageControl: PlayerPageControl!
    
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var volumeButton: UIButton!
    
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var volumeView: PlayerVolumeView!
    
    var store: PlayerStore!
    var action: PlayerAction!
    
    var controllers: [UIViewController] = []
    
    var timer: PlayerTimer!

    // MARK Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.configure(controllers: controllers, pageControl: pageControl, containerController: self)
        progressBar.configure()
        pageControl.configure()
        
        bindStore()
        bindAction()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.stop()
    }
    
    // MARK: Actions
    
    @IBAction func backButtonTapped(_ backButton: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

// MARK: Store

extension PlayerViewController {
    
    func bindStore() {
        store.playButtonState.asObservable()
            .filter { $0 == .playing }
            .subscribe(onNext: { [weak self] _ in
                self?.playButton.updatePlayingState()
            })
            .addDisposableTo(rx_disposeBag)
        
        store.playButtonState.asObservable()
            .filter { $0 == .paused }
            .subscribe(onNext: { [weak self] _ in
                self?.playButton.updatePausedState()
            })
            .addDisposableTo(rx_disposeBag)
        
        store.repeatMode.asObservable()
            .subscribe(onNext: { [weak self] mode in
                switch mode {
                case .flow:         self?.repeatButton.setImage(#imageLiteral(resourceName: "repeat_flow"), for: .normal)
                case .repeat:       self?.repeatButton.setImage(#imageLiteral(resourceName: "repeat"), for: .normal)
                case .repeatOne:    self?.repeatButton.setImage(#imageLiteral(resourceName: "repeat_one"), for: .normal)
                case .shuffle:      self?.repeatButton.setImage(#imageLiteral(resourceName: "repeat_shuffle"), for: .normal)
                }
            })
            .addDisposableTo(rx_disposeBag)
        
        store.duration.asObservable()
            .bind(to: progressBar.rx.duration)
            .addDisposableTo(rx_disposeBag)
        
        store.currentTime.asObservable()
            .bind(to: progressBar.rx.currentTime)
            .addDisposableTo(rx_disposeBag)
        
        store.track.asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] track in
                self?.backgroundImageView.fadeImage(track.avatar, placeholder: nil, duration: 1)
            })
            .addDisposableTo(rx_disposeBag)
        
        let volumeEnabled = store.volumeEnabled.asObservable()
            .skip(1)
            .distinctUntilChanged()
            .shareReplay(1)
        
        volumeEnabled
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                guard let this = self else { return }
                
                this.volumeView.isHidden = false
                this.panelView.isHidden = false
                
                this.volumeView.alpha = 0
                this.panelView.alpha = 1
                
                UIView.animate(withDuration: 0.2, animations: {
                    this.volumeView.alpha = 1
                    this.panelView.alpha = 0
                }, completion: { _ in
                    this.volumeView.isHidden = false
                    this.panelView.isHidden = true
                })
            })
            .addDisposableTo(rx_disposeBag)
        
        volumeEnabled
            .filter { !$0 }
            .subscribe(onNext: { [weak self] _ in
                guard let this = self else { return }
                
                this.volumeView.isHidden = false
                this.panelView.isHidden = false
                
                this.volumeView.alpha = 1
                this.panelView.alpha = 0
                
                UIView.animate(withDuration: 0.2, animations: {
                    this.volumeView.alpha = 0
                    this.panelView.alpha = 1
                }, completion: { _ in
                    this.volumeView.isHidden = true
                    this.panelView.isHidden = false
                })
            })
            .addDisposableTo(rx_disposeBag)
    }
}

// MARK: Action

extension PlayerViewController {
    
    func bindAction() {
        playButton.action = action.onPlayButtonPress()
        backwardButton.rx.action = action.onBackwardPress()
        forwardButton.rx.action = action.onForwardPress()
        repeatButton.rx.action = action.onRepeatPress()
        refreshButton.rx.action = action.onRefreshPress()
        
        progressBar.endDraggingAction = action.onProgressBarDidEndDragging()
        
        heartButton.rx.action = action.onHeartButtonPress()
        downloadButton.rx.action = action.onDownloadButtonPress()
        shareButton.rx.action = action.onShareButtonPress()
        
        calendarButton.rx.action = CocoaAction { [weak self] in
            self?.timer.presentPanel() ?? .empty()
        }
        
        volumeButton.rx.action = action.onVolumeButtonPress()
        volumeView.action = action.onVolumeButtonPress()
    }
    
}
