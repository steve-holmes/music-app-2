//
//  DetailInitialActivityIndicatorView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/19/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DetailInitialActivityIndicatorView: UIView {

    fileprivate var indicatorView: NVActivityIndicatorView!
    fileprivate(set) weak var sourceView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        indicatorView = NVActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: 30, height: 30),
            type: .lineScale,
            color: .toolbarImage,
            padding: nil
        )
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(indicatorView)
        
        let size: CGFloat = 30
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: size),
            indicatorView.heightAnchor.constraint(equalToConstant: size)
        ])
        
        self.layoutIfNeeded()
    }
    
}

extension DetailInitialActivityIndicatorView {
    
    func startAnimating(in view: UIView?) {
        let sourceView = view ?? getWindow()
        self.sourceView = sourceView
        
        self.translatesAutoresizingMaskIntoConstraints = false
        sourceView.addSubview(self)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: sourceView.leadingAnchor),
            trailingAnchor.constraint(equalTo: sourceView.trailingAnchor),
            bottomAnchor.constraint(equalTo: sourceView.bottomAnchor),
            heightAnchor.constraint(equalTo: sourceView.heightAnchor, multiplier: 2.0/3.0)
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
