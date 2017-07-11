//
//  PlayerTimerViewController.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/26/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Action
import NSObject_Rx

fileprivate let kPlayerTimerSelectedIndex = "PlayerTimerSelectedIndex"

class PlayerTimerViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timelineView: UIView!
    @IBOutlet weak var timelineBar: UIView!
    
    @IBOutlet weak var selectedNodeView: UIView!
    @IBOutlet weak var selectedNodeLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet var timeLabels: [UILabel]!
    @IBOutlet var timeNodeViews: [UIView]!
    @IBOutlet var timeLabelBottomConstraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var timerButton: UIButton!
    
    // MARK: Input Properties
    
    var timerEnabled: Bool = false
    
    var currentTime: Int = 0
    
    // MARK: Output Properties
    
    private let timeSubject = PublishSubject<Int?>()
    lazy var timeOutput: Observable<Int?> = { return self.timeSubject.asObservable() }()
    
    // MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureGestureRecognier()
        configureTimer()
        configureTimerButton()
        selectedNodeView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectedIndex = UserDefaults.standard.integer(forKey: kPlayerTimerSelectedIndex)
        select(at: selectedIndex, animated: false)
        UIView.animate(withDuration: 0.2) { 
            self.selectedNodeView.alpha = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerSubscription?.dispose()
        timeSubject.onCompleted()
    }
    
    // MARK: Configuration
    
    private func configure() {
        for nodeView in timeNodeViews {
            nodeView.layer.cornerRadius = 3
        }
        
        selectedNodeView.subviews[0].layer.cornerRadius = 6
        selectedNodeView.subviews[1].layer.cornerRadius = 3
        
        timerButton.layer.cornerRadius = 5
    }
    
    private func configureTimerButton() {
        timerButton.rx.action = CocoaAction {
            if !self.timerEnabled {
                switch self.selectedIndex {
                case 0: self.timeSubject.onNext(5 * 60)
                case 1: self.timeSubject.onNext(15 * 60)
                case 2: self.timeSubject.onNext(30 * 60)
                case 3: self.timeSubject.onNext(45 * 60)
                case 4: self.timeSubject.onNext(60 * 60)
                default: break
                }
            } else {
                self.timeSubject.onNext(nil)
            }
            self.dismiss(animated: true, completion: nil)
            return .empty()
        }
    }
    
    // MARK: Offsets
    
    private lazy var nodeDistance: CGFloat  = self.timelineBar.bounds.width / 4
    
    private lazy var nodeOffsets: [CGFloat] = {
        return self.timeNodeViews.map { nodeView in
            let location = CGPoint(x: nodeView.frame.midX, y: nodeView.frame.midY)
            return self.timelineView.convert(location, from: nodeView.superview!).x
        }
    }()
    
    // MARK: Tap Gesture Recognizer
    
    private func configureGestureRecognier() {
        self.view.rx.tapGesture()
            .skip(1)
            .subscribe(onNext: { [weak self] tapGesture in
                self?.tapGestureRecognizerDidRecevice(tapGesture)
            })
            .addDisposableTo(rx_disposeBag)
    }

    
    private func tapGestureRecognizerDidRecevice(_ tapGesture: UITapGestureRecognizer) {
        let offset = tapGesture.location(in: timelineView).x
        
        let distances = nodeOffsets.map { nodeOffset in fabs(offset - nodeOffset) }
        
        var minOffsetIndex = -1
        var minDistance = self.view.bounds.width
        
        for index in 0 ..< distances.count {
            if distances[index] < minDistance {
                minDistance = distances[index]
                minOffsetIndex = index
            }
        }
        
        select(at: minOffsetIndex)
    }
    
    // MARK: Selection
    
    private let unselectTextColor = UIColor(withIntWhite: 153)
    
    private var selectedIndex: Int!
    
    func select(at index: Int, animated: Bool = true) {
        
        func getSelectedNodeOffset(at index: Int) -> CGFloat {
            switch index {
            case 1: return nodeDistance
            case 2: return nodeDistance * 2
            case 3: return nodeDistance * 3
            case 4: return nodeDistance * 4
            default: return 0
            }
        }
        
        func updateForNormalState(at index: Int) {
            timeLabels[index].textColor = unselectTextColor
            timeLabelBottomConstraints[index].constant = 5
            selectedNodeLeadingConstraint.constant = -6 + getSelectedNodeOffset(at: index)
        }
        
        func updateForSelectedState(at index: Int) {
            timeLabels[index].textColor = .black
            timeLabelBottomConstraints[index].constant = 10
            selectedNodeLeadingConstraint.constant = -6 + getSelectedNodeOffset(at: index)
        }
        
        func updateTimeline() {
            if let deselectedIndex = selectedIndex {
                updateForNormalState(at: deselectedIndex)
            }
            updateForSelectedState(at: index)
            
            selectedIndex = index
            view.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                updateTimeline()
            }
        } else {
            updateTimeline()
        }
        
        UserDefaults.standard.set(selectedIndex, forKey: kPlayerTimerSelectedIndex)
    }
    
    // MARK: Timer
    
    private var timerSubscription: Disposable?
    
    private func configureTimer() {
        if timerEnabled {
            timerButton.setTitle("Tắt Hẹn Giờ", for: .normal)
            
            let timerFormatter = DateFormatter()
            timerFormatter.dateFormat = "mm:ss"
            
            timerSubscription = Observable<Int>.timer(0, period: 1, scheduler: MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    guard let this = self else { return }
                    this.currentTime -= 1
                    this.timeLabel.text = timerFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(this.currentTime)))
                    
                    if this.currentTime == 0 {
                        this.timerSubscription?.dispose()
                        this.dismiss(animated: true, completion: nil)
                    }
                })
        } else {
            timerButton.setTitle("Bật Hẹn Giờ", for: .normal)
            timeLabel.text = nil
        }
    }
    
}
