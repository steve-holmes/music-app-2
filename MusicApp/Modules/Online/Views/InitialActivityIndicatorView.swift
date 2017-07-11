//
//  InitialActivityIndicatorView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/19/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class InitialActivityIndicatorView: UIView {

    fileprivate var indicatorView: NVActivityIndicatorView!
    fileprivate(set) weak var sourceView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        indicatorView = NVActivityIndicatorView(
            frame: .zero,
            type: .lineScale,
            color: .toolbarImage,
            padding: nil
        )
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -79),
            indicatorView.widthAnchor.constraint(equalToConstant: 40),
            indicatorView.widthAnchor.constraint(equalTo: indicatorView.heightAnchor)
        ])
    }
    
}

extension InitialActivityIndicatorView {
    
    func startAnimating(in view: UIView?) {
        let sourceView = view ?? getWindow()
        self.sourceView = sourceView
        
        self.translatesAutoresizingMaskIntoConstraints = false
        sourceView.addSubview(self)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: sourceView.topAnchor),
            bottomAnchor.constraint(equalTo: sourceView.bottomAnchor),
            leadingAnchor.constraint(equalTo: sourceView.leadingAnchor),
            trailingAnchor.constraint(equalTo: sourceView.trailingAnchor)
        ])
        
        sourceView.layoutIfNeeded()
        
        indicatorView.startAnimating()
    }
    
    func stopAnimating() {
        indicatorView.stopAnimating()
        
        self.removeFromSuperview()
    }
    
    private func getWindow() -> UIView {
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        return applicationDelegate.window!
    }
    
}
