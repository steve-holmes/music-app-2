//
//  PlayerProgressBar.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/24/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Action
import NSObject_Rx

class PlayerProgressBar: UIView {
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var currentTimeView: UIView!
    
    @IBOutlet weak var currentTimeViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var currentTimeBarEqualWidthConstraint: NSLayoutConstraint!
    
    private var isDragging: Bool = false
    
    // MARK: Action
    
    var endDraggingAction: Action<Int, Void>?
    
    // MARK: Configuration
    
    private var currentTimeViewWidth: CGFloat!
    private var currentTimeBarWidth: CGFloat!
    
    func configure() {
        configureDraggingEvent()
        currentTimeView.layer.cornerRadius = currentTimeView.bounds.height / 2
        
        currentTimeViewWidth = frame.width - currentTimeView.frame.width
        currentTimeBarWidth = frame.width - currentTimeView.frame.width / 2
        
        currentTimeBarEqualWidthConstraint.constant = -currentTimeBarWidth
    }
    
    // MARK: Current Time, Duration
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        return formatter
    }()
    
    var currentTime: Int = 0 {
        didSet {
            if isDragging { return }
            
            let time = Date(timeIntervalSince1970: TimeInterval(currentTime))
            currentTimeLabel.text = formatter.string(from: time)
            
            if duration != 0 {
                let completePercent = 1.0 - CGFloat(duration - currentTime) / CGFloat(duration)
                currentTimeViewLeadingConstraint.constant = completePercent * currentTimeViewWidth
                currentTimeBarEqualWidthConstraint.constant = (completePercent - 1.0) * currentTimeBarWidth
            }
        }
    }
    
    var duration: Int = 0 {
        didSet {
            let time = Date(timeIntervalSince1970: TimeInterval(duration))
            durationLabel.text = formatter.string(from: time)
        }
    }
    
    // MARK: Pan Gesture Event
    
    private func configureDraggingEvent() {
        
        func getCurrentTime(from offset: CGFloat) -> Int {
            var currentTime = 0
            
            if offset < self.currentTimeView.frame.width / 2 {
                currentTime = 0
            } else if offset > self.frame.width - self.currentTimeView.frame.width / 2 {
                currentTime = self.duration
            } else {
                currentTime = Int(offset / self.frame.width * CGFloat(self.duration))
            }
            
            return currentTime
        }
        
        let tooltipView = PlayerTooltipView(frame: .zero)
        
        let panGesture = currentTimeView.rx.panGesture()
            .shareReplayLatestWhileConnected()
        
        panGesture
            .filter { panGesture in panGesture.state == .began }
            .subscribe(onNext: { [weak self] panGesture in
                self?.isDragging = true
                tooltipView.sibling(to: self!.currentTimeView, in: self!)
            })
            .addDisposableTo(rx_disposeBag)
        
        panGesture
            .filter { panGesture in panGesture.state == .changed }
            .subscribe(onNext: { [weak self] panGesture in
                guard let `self` = self else { return }
                
                let offset = panGesture.location(in: self).x
                self.currentTimeBarEqualWidthConstraint.constant = offset - self.frame.width
                self.currentTimeViewLeadingConstraint.constant = offset - self.currentTimeView.frame.width / 2
                
                let currentTime = getCurrentTime(from: offset)
                
                let time = Date(timeIntervalSince1970: TimeInterval(currentTime))
                let timeString = self.formatter.string(from: time)
                self.currentTimeLabel.text = timeString
                tooltipView.time = timeString
            })
            .addDisposableTo(rx_disposeBag)
        
        panGesture
            .filter { panGesture in panGesture.state == .ended || panGesture.state == .cancelled }
            .subscribe(onNext: { [weak self] panGesture in
                self?.isDragging = false
                tooltipView.removeFromSuperview()
                
                let currentTime = getCurrentTime(from: panGesture.location(in: self).x)
                self?.endDraggingAction?.execute(currentTime)
            })
            .addDisposableTo(rx_disposeBag)
    }
    

}
