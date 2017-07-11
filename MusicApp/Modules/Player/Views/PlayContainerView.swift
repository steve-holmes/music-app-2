//
//  PlayContainerView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/23/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx



class PlayContainerView: UIScrollView {

    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var lyricView: UIView!
    
    var position: PlayerStorage.Position {
        get {
            return PlayerStorage.shared.position
        }
        set {
            PlayerStorage.shared.position = newValue
        }
    }
    
    func configure(controllers: [UIViewController], pageControl: PlayerPageControl, containerController: UIViewController) {
        if controllers.count < 3 { return }
        addControllers(controllers, containerController: containerController)
        configureDidScrollEvent()
        setCurrentContentOffset()
        configureDidEndDeceleratingEvent(pageControl: pageControl)
    }
    
    private func addControllers(_ controllers: [UIViewController], containerController: UIViewController) {
        containerController.addController(controllers[0], in: listView)
        containerController.addController(controllers[1], in: informationView)
        containerController.addController(controllers[2], in: lyricView)
    }
    
    private func setCurrentContentOffset() {
        switch position {
        case .list:
            setContentOffset(.zero, animated: false)
        case .lyric:
            setContentOffset(CGPoint(x: frame.width * 2, y: 0), animated: false)
        default:
            setContentOffset(CGPoint(x: frame.width, y: 0), animated: false)
        }
    }
    
    private func configureDidScrollEvent() {
        let endScale: CGFloat = 0.9
        let distance: CGFloat = bounds.width / 10
        
        func scale(_ offset: CGFloat, in view: UIView) {
            if offset > -distance && offset < distance {
                let scale = 1.0 - (1.0 - endScale) * fabs(offset) / distance
                view.layer.transform = CATransform3DMakeScale(scale, scale, scale)
                return
            }
            
            view.layer.transform = CATransform3DMakeScale(endScale, endScale, endScale)
        }
        
        func scaleListView(_ offset: CGFloat) {
            scale(offset, in: listView)
        }
        
        func scaleInformationView(_ offset: CGFloat) {
            var informationOffset = offset
            
            if offset > bounds.width - distance && offset < bounds.width + distance {
                informationOffset -= bounds.width
            }
            
            scale(informationOffset, in: informationView)
        }
        
        func scaleLyricView(_ offset: CGFloat) {
            var lyricOffset: CGFloat = offset
            
            if offset > 2 * bounds.width - distance && offset < 2 * bounds.width + distance {
                lyricOffset -= 2 * bounds.width
            }
            
            scale(lyricOffset, in: lyricView)
        }
        
        self.rx.didScroll
            .map { [weak self] in self?.contentOffset.x ?? 0 }
            .subscribe(onNext: { offset in
                scaleListView(offset)
                scaleInformationView(offset)
                scaleLyricView(offset)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    private func configureDidEndDeceleratingEvent(pageControl: PlayerPageControl) {
        
        func equal(_ source: CGFloat, to destination: CGFloat, inTolerance tolerance: CGFloat) -> Bool {
            return destination - tolerance <= source && source <= destination + tolerance
        }
        
        let width = frame.width
        
        self.rx.didEndDecelerating
            .map { [weak self] _ in self?.contentOffset.x ?? 0 }
            .subscribe(onNext: { [weak self] offset in
                if equal(offset, to: 0, inTolerance: 0.2) {
                    self?.position = .list
                    pageControl.currentPage = 0
                }
                if equal(offset, to: width, inTolerance: 0.2) {
                    self?.position = .information
                    pageControl.currentPage = 1
                }
                if equal(offset, to: width * 2, inTolerance: 0.2) {
                    self?.position = .lyric
                    pageControl.currentPage = 2
                }
            })
            .addDisposableTo(rx_disposeBag)
    }

}
