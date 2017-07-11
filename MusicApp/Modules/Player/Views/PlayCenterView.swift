//
//  PlayCenterView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/24/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class PlayCenterView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageEffectView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureHighlighting()
    }
    
    // MARK: Properties
    
    var action: CocoaAction? {
        get { return playButton.rx.action }
        set { playButton.rx.action = newValue }
    }
    
    // MARK: State
    
    private enum State {
        case playing
        case paused
    }
    
    private var state: State = .paused
    
    // MARK: Playing / Paused
    
    func updatePlayingState() {
        state = .playing
        imageView.image = #imageLiteral(resourceName: "pause")
        stopEffectAnimation()
    }
    
    func updatePausedState() {
        state = .paused
        imageView.image = #imageLiteral(resourceName: "play")
        startEffectAnimation()
    }
    
    // MARK: Highlighting
    
    private func configureHighlighting() {
        playButton.rx.controlEvent(.touchDown)
            .subscribe(onNext: { [weak self] _ in
                self?.updateHighlightState()
            })
            .addDisposableTo(rx_disposeBag)
        
        playButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                self?.updateUnhighlightState()
            })
            .addDisposableTo(rx_disposeBag)
        
        playButton.rx.controlEvent(.touchUpOutside)
            .subscribe(onNext: { [weak self] _ in
                self?.updateUnhighlightState()
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    private func updateHighlightState() {
        switch state {
        case .playing:
            imageView.image = #imageLiteral(resourceName: "pause_highlight")
        case .paused:
            imageView.image = #imageLiteral(resourceName: "play_highlight")
            stopEffectAnimation()
            imageEffectView.alpha = 1
        }
    }
    
    private func updateUnhighlightState() {
        switch state {
        case .playing:
            imageView.image = #imageLiteral(resourceName: "pause")
        case .paused:
            imageView.image = #imageLiteral(resourceName: "play")
            startEffectAnimation()
        }
    }
    
    // MARK: Start/ Stop animating play button effect
    
    private let effectDuration: TimeInterval = 2
    
    private func startEffectAnimation() {
        imageEffectView.alpha = 0
        UIView.animate(
            withDuration: effectDuration,
            delay: 0,
            options: [.repeat, .autoreverse, .beginFromCurrentState],
            animations: { [weak self] in
                self?.imageEffectView.alpha = 1
            },
            completion: nil
        )
    }
    
    private func stopEffectAnimation() {
        imageEffectView.layer.removeAllAnimations()
        imageEffectView.alpha = 0
    }

}
