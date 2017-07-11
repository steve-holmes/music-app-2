//
//  PlayerTimer.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/27/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import RxSwift
import Action

protocol PlayerTimer {
    
    func presentPanel() -> Observable<Void>
    func stop()
    
}

class MAPlayerTimer: PlayerTimer {
    
    weak var controller: UIViewController!
    var action: PlayerAction!
    
    private var timer: Timer?
    private var startTime: Date?
    private var duration: Int = 0
    
    func presentPanel() -> Observable<Void> {
        let durationTimeInterval = startTime != nil ? Date().timeIntervalSince(startTime!) : nil
        let duration: Int? = durationTimeInterval != nil ? self.duration - Int(durationTimeInterval!) : nil
        let timerInfo = TimerInfo(time: duration, controller: controller)
        
        return action.onCalendarButtonPress.execute(timerInfo)
            .do(onNext: { [weak self] time in
                if let duration = time {
                    self?.startTimer(duration)
                } else {
                    self?.stopTimer()
                    StatusBarNotificationBanner(title: "Đã tắt chế độ hẹn giờ", style: .info).show()
                }
            })
            .map { _ in }
    }
    
    func stop() {
        stopTimer()
    }
    
    private func startTimer(_ duration: Int) {
        stopTimer()
        
        startTime = Date()
        self.duration = duration
        
        let status = "Sau \(duration / 60) phút ngừng phát nhạc"
        StatusBarNotificationBanner(title: status, style: .info).show()
        
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(duration), repeats: false) { [weak self] timer in
            StatusBarNotificationBanner(title: "Ngừng phát nhạc", style: .info).show()
            self?.action.onPause.execute(())
            self?.stopTimer()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
    }
    
}
