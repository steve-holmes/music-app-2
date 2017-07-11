//
//  VideoPlayerView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/2/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class VideoPlayerView: UIView {
    
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var controlView: UIView!
    
    fileprivate var seekingView = VideoSeekingPlayerView()
    
    fileprivate weak var videoPlayer: VideoPlayer?
    
    fileprivate var isCurrentTimeUpdating: Bool = true
    fileprivate var musicPlayerPauseEnabled: Bool = false
    
    private var isPlaying: Bool = true {
        didSet {
            if isPlaying { videoPlayer?.play() }
            else { videoPlayer?.pause() }
        }
    }
    
    func timeSliderValueChanged(_ slider: UISlider) {
        videoPlayer?.seek(Int(slider.value))
    }
    
    func timeSliderTouchDown(_ slider: UISlider) {
        isCurrentTimeUpdating = false
    }
    
    func timeSliderTouchDragInside(_ slider: UISlider) {
        deplayHidingControlView()
    }
    
    func timeSliderTouchDragOutside(_ slider: UISlider) {
        deplayHidingControlView()
    }
    
    @IBAction func playButtonTapped(_ playButton: UIButton) {
        deplayHidingControlView()
        isPlaying = !isPlaying
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timeSlider.setThumbImage(#imageLiteral(resourceName: "video_thumb"), for: .normal)
        timeSlider.addTarget(self, action: #selector(timeSliderTouchDown(_:)), for: .touchDown)
        timeSlider.addTarget(self, action: #selector(timeSliderTouchDragInside(_:)), for: .touchDragInside)
        timeSlider.addTarget(self, action: #selector(timeSliderTouchDragOutside(_:)), for: .touchDragOutside)
        timeSlider.addTarget(self, action: #selector(timeSliderValueChanged(_:)), for: .valueChanged)
        
        controlView.isHidden = true
        controlView.alpha = 0
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(controlViewTapGestureRecognizerDidReceive(_:))))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerDidReceive(_:))))
        
        observeIsPlayingNotification()
        observeMusicCenter()
    }
    
    func configure(player: VideoPlayer) {
        self.videoPlayer = player
        self.player = videoPlayer?.player
        self.videoPlayer?.delegate = self
    }
    
    func controlViewTapGestureRecognizerDidReceive(_ tapGestureRecognizer: UITapGestureRecognizer) {
        controlView.isHidden = false
        UIView.animate(withDuration: 0.2, animations: { 
            self.controlView.alpha = 1
        }) { _ in
            self.deplayHidingControlView()
        }
    }
    
    private func deplayHidingControlView() {
        VideoPlayerView.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.hideControlView), object: nil)
        self.perform(#selector(self.hideControlView), with: nil, afterDelay: 5)
    }
    
    func hideControlView() {
        UIView.animate(withDuration: 0.2, animations: { 
            self.controlView.alpha = 0
        }) { _ in
            self.controlView.isHidden = true
        }
    }
    
    private var isHorizontal: Bool = true
    private var startSliderValue: Float = 0
    
    private let volumeSlider: UISlider = {
        let volumeView = MPVolumeView()
        return volumeView.volumeSlider
    }()
    
    func panGestureRecognizerDidReceive(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self)
        
        switch gestureRecognizer.state {
        case .began:
            isHorizontal = translation.x > translation.y
            startSliderValue = (isHorizontal && videoPlayer != nil) ? Float(videoPlayer!.currentTime) : volumeSlider.value
        case .changed:
            if isHorizontal {
                
            } else {
                volumeSlider.value = startSliderValue - Float(translation.y / bounds.height)
            }
        default:
            break
        }
    }

    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        return formatter
    }()
    
    fileprivate var player: AVPlayer? {
        get { return (layer as? AVPlayerLayer)?.player }
        set { (layer as? AVPlayerLayer)?.player = newValue }
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

}

extension VideoPlayerView: VideoPlayerDelegate {
    
    func videoPlayerWillLoad(_ player: VideoPlayer) {
        self.player = player.player
        postIsPlayingNotification()
    }
    
    func videoPlayerDidPlay(_ player: VideoPlayer) {
        playImageView.image = #imageLiteral(resourceName: "video_pause")
    }
    
    func videoPlayerWillPause(_ player: VideoPlayer) {
        playImageView.image = #imageLiteral(resourceName: "video_play")
    }
    
    func videoPlayerDidPause(_ player: VideoPlayer) {
        playImageView.image = #imageLiteral(resourceName: "video_play")
    }
    
    func videoPlayerDidStop(_ player: VideoPlayer) {
        if musicPlayerPauseEnabled {
            NotificationCenter.default.post(name: .MusicCenterPlay, object: self)
        }
    }
    
    func videoPlayer(_ player: VideoPlayer, didGetCurrentTime currentTime: Int) {
        guard isCurrentTimeUpdating else { return }
        currentTimeLabel.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(currentTime)))
        timeSlider.value = Float(currentTime)
    }
    
    func videoPlayer(_ player: VideoPlayer, didGetDuration duration: Int) {
        durationLabel.text = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(duration)))
        timeSlider.maximumValue = Float(duration)
    }
    
    func videoPlayer(_ player: VideoPlayer, willSeekToTime time: Int) {
        seekingView.startAnimating(in: self.controlView)
    }
    
    func videoPlayer(_ player: VideoPlayer, didSeekToTime time: Int) {
        videoPlayer(player, didGetCurrentTime: time)
        
        seekingView.stopAnimating()
        isCurrentTimeUpdating = true
    }
    
    func videoPlayer(_ player: VideoPlayer, failSeekToTime time: Int) {
        seekingView.stopAnimating()
        isCurrentTimeUpdating = true
    }
    
}

extension VideoPlayerView {
    
    fileprivate func postIsPlayingNotification() {
        NotificationCenter.default.post(name: .MusicCenterPlayerIsPlaying, object: self)
    }
    
    fileprivate func observeIsPlayingNotification() {
        NotificationCenter.default.addObserver(forName: .MusicCenterDidGetIsPlaying, object: nil, queue: nil) { [weak self] notification in
            if let isPlaying = notification.userInfo?[kMusicCenterIsPlaying] as? Bool, isPlaying {
                self?.musicPlayerPauseEnabled = true
                NotificationCenter.default.post(name: .MusicCenterPause, object: self)
            }
        }
    }
    
    fileprivate func observeMusicCenter() {
        NotificationCenter.default.addObserver(forName: .MusicCenterDidPlay, object: nil, queue: nil) { [weak self] _ in
            if self?.musicPlayerPauseEnabled == true {
                self?.musicPlayerPauseEnabled = false
                self?.videoPlayer?.pause()
            }
        }
        
        NotificationCenter.default.addObserver(forName: .MusicCenterDidPause, object: nil, queue: nil) { [weak self] _ in
            if self?.musicPlayerPauseEnabled == false {
                self?.musicPlayerPauseEnabled = true
                self?.videoPlayer?.play()
            }
        }
    }
    
}

fileprivate extension MPVolumeView {
    
    var volumeSlider: UISlider {
        self.showsRouteButton = false
        self.showsVolumeSlider = false
        self.isHidden = true
        var slider = UISlider()
        for subview in self.subviews {
            if subview is UISlider {
                slider = subview as! UISlider
                slider.isContinuous = false
                (subview as! UISlider).value = AVAudioSession.sharedInstance().outputVolume
                return slider
            }
        }
        return slider
    }
    
}
