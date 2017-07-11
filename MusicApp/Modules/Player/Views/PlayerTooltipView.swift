//
//  PlayerTooltipView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 6/24/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit

class PlayerTooltipView: UIView {

    private var timeLabel: UILabel!
    
    var time: String = "00:00" {
        didSet {
            timeLabel?.text = time
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.textColor = .white
        timeLabel.font = UIFont(name: "AvenirNext-Regular", size: 12)
        
        backgroundColor = .black
        
        let height: CGFloat = 20
        layer.cornerRadius = height / 2
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func sibling(to view: UIView, in superview: UIView) {
        superview.addSubview(self)
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.5),
            bottomAnchor.constraint(equalTo: view.topAnchor, constant: -10)
        ])
        
        layoutIfNeeded()
    }

}
