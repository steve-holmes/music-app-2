//
//  VideoSeekingPlayerView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/11/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class VideoSeekingPlayerView: UIView {

    private let indicatorView: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(
            frame: .zero,
            type: .ballClipRotateMultiple,
            color: .white,
            padding: nil
        )
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let indicator = self.indicatorView
        containerView.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            indicator.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.25),
            indicator.widthAnchor.constraint(equalTo: indicator.heightAnchor)
        ])
        
        return containerView
    }()
    
    private let duration: TimeInterval = 0.25
    
    func startAnimating(in view: UIView?) {
        let sourceView = view != nil ? view! : getWindow()
        
        containerView.alpha = 0
        containerView.isHidden = true
        
        containerView.frame = sourceView.bounds
        sourceView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: sourceView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: sourceView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: sourceView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: sourceView.trailingAnchor)
        ])
        
        containerView.isHidden = false
        
        UIView.animate(withDuration: duration) { [weak self] in
            self?.containerView.alpha = 1
        }
    }
    
    func stopAnimating() {
        containerView.alpha = 1
        containerView.isHidden = false
        
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.containerView.alpha = 0
        }) { [weak self] _ in
            self?.containerView.isHidden = true
            self?.containerView.removeFromSuperview()
        }
    }
    
    private func getWindow() -> UIView {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.window!
    }

}
