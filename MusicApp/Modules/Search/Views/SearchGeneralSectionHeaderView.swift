//
//  SearchGeneralSectionHeaderView.swift
//  MusicApp
//
//  Created by Hưng Đỗ on 7/12/17.
//  Copyright © 2017 HungDo. All rights reserved.
//

import UIKit
import Action

class SearchGeneralSectionHeaderView: UIView {
    
    private var titleLabel: UILabel!
    private var moreButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        self.backgroundColor = .background
        self.alpha = 0.9
        
        configureLabel()
        configureButton()
    }
    
    private func configureLabel() {
        titleLabel = UILabel()
        titleLabel.textColor = .main
        titleLabel.font = .avenirNextFont()
        titleLabel.text = title
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func configureButton() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            containerView.widthAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "right_arrow").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .text
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.6)
        ])
        
        moreButton = UIButton()
        moreButton.rx.action = self.action
        
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(moreButton)
        
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            moreButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            moreButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            moreButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var action: CocoaAction? {
        didSet {
            moreButton.rx.action = action
        }
    }

}
